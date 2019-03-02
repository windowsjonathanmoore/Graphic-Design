
/* 
   rtopensl.c
   OpenSl ES Audio Module for Csound                        

   Copyright (C) 2011 Victor Lazzarini.

   This file is part of Csound.

   The Csound Library is free software; you can redistribute it
   and/or modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   Csound is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with Csound; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA

*/
#include <SLES/OpenSLES.h>
#include "SLES/OpenSLES_Android.h"
#include "csdl.h"
#include <android/log.h> 

typedef struct OPEN_SL_PARAMS_ {

  CSOUND      *csound;

  // engine interfaces
  SLObjectItf engineObject;
  SLEngineItf engineEngine;

  // output mix interfaces
  SLObjectItf outputMixObject;

  // buffer queue player interfaces
  SLObjectItf bqPlayerObject;
  SLPlayItf bqPlayerPlay;
  SLAndroidSimpleBufferQueueItf bqPlayerBufferQueue;
  SLEffectSendItf bqPlayerEffectSend;

  // recorder interfaces
  SLObjectItf recorderObject;
  SLRecordItf recorderRecord;
  SLAndroidSimpleBufferQueueItf recorderBufferQueue;

  // buffers  
  MYFLT *outputBuffer;
  MYFLT *inputBuffer;
  short *recBuffer;
  short *playBuffer;
  int outBufSamples;
  int inBufSamples;

  // circular buffers
  void *incb;
  void *outcb;

  // parameters
  csRtAudioParams outParm;
  csRtAudioParams inParm;

} open_sl_params;

#define CONV16BIT 32768
#define CONVMYFLT FL(1./32768.)

// this callback handler is called every time a buffer finishes playing
void bqPlayerCallback(SLAndroidSimpleBufferQueueItf bq, void *context)
{
  open_sl_params *p = (open_sl_params *) context;
  int items = p->outBufSamples, i, r = 0;
  CSOUND *csound = p->csound;
  MYFLT *outputBuffer = p->outputBuffer;
  short *playBuffer = p->playBuffer;
  csound->ReadCircularBuffer(csound,p->outcb,outputBuffer,items);
  for(i=0;i < items; i++) 
    playBuffer[i] = (short) (outputBuffer[i]*CONV16BIT);
  (*p->bqPlayerBufferQueue)->Enqueue(p->bqPlayerBufferQueue,playBuffer,items*sizeof(short));
}



/* put samples to DAC */
void androidrtplay_(CSOUND *csound, const MYFLT *buffer, int nbytes)
{
  open_sl_params *p;
  int n = nbytes/sizeof(MYFLT);
  int m = 0, l;
  p = (open_sl_params *) *(csound->GetRtPlayUserData(csound));
  do{
    l = csound->WriteCircularBuffer(csound,p->outcb,&buffer[m],n); 
    m += l;
    n -= l; 
  } while(n); 
}

SLresult openSLCreateEngine(open_sl_params *params)
{
  SLresult result;

  // create engine
  result = slCreateEngine(&(params->engineObject), 0, NULL, 0, NULL, NULL);
  if(result != SL_RESULT_SUCCESS) goto engine_end;

  // realize the engine 
  result = (*params->engineObject)->Realize(params->engineObject, SL_BOOLEAN_FALSE);
  if(result != SL_RESULT_SUCCESS) goto engine_end;

  // get the engine interface, which is needed in order to create other objects
  result = (*params->engineObject)->GetInterface(params->engineObject, SL_IID_ENGINE, &(params->engineEngine));
  if(result != SL_RESULT_SUCCESS) goto engine_end;

 engine_end:
  return result;
}

int openSLPlayOpen(open_sl_params *params)
{
  SLresult result;
  SLuint32 sr = params->outParm.sampleRate;

  // configure audio source
  SLDataLocator_AndroidSimpleBufferQueue loc_bufq = {SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 2};

  switch(sr){

  case 8000:
    sr = SL_SAMPLINGRATE_8;
    break;
  case 11025:
    sr = SL_SAMPLINGRATE_11_025;
    break;
  case 16000:
    sr = SL_SAMPLINGRATE_16;
    break;
  case 22050:
    sr = SL_SAMPLINGRATE_22_05;
    break;
  case 24000:
    sr = SL_SAMPLINGRATE_24;
    break;
  case 32000:
    sr = SL_SAMPLINGRATE_32;
    break;
  case 44100:
    sr = SL_SAMPLINGRATE_44_1;
    break;
  case 48000:
    sr = SL_SAMPLINGRATE_48;
    break;
  case 64000:
    sr = SL_SAMPLINGRATE_64;
    break;
  case 88200:
    sr = SL_SAMPLINGRATE_88_2;
    break;
  case 96000:
    sr = SL_SAMPLINGRATE_96;
    break;
  case 192000:
    sr = SL_SAMPLINGRATE_192;
    break;
  default:
    return -1;
  }
   
  const SLInterfaceID ids[] = {SL_IID_VOLUME};
  const SLboolean req[] = {SL_BOOLEAN_FALSE};
  result = (*params->engineEngine)->CreateOutputMix(params->engineEngine, &(params->outputMixObject), 1, ids, req);
  if(result != SL_RESULT_SUCCESS) goto end_openaudio;

  // realize the output mix
  result = (*params->outputMixObject)->Realize(params->outputMixObject, SL_BOOLEAN_FALSE);
  int chnls = params->csound->GetNchnls(params->csound);
  int speakers;
  if(chnls == 1) speakers =  SL_SPEAKER_FRONT_CENTER;
  else speakers = SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT;

  SLDataFormat_PCM format_pcm = {SL_DATAFORMAT_PCM, chnls , sr,
				 SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16,
				 speakers, SL_BYTEORDER_LITTLEENDIAN};

  SLDataSource audioSrc = {&loc_bufq, &format_pcm};

  // configure audio sink
  SLDataLocator_OutputMix loc_outmix = {SL_DATALOCATOR_OUTPUTMIX, params->outputMixObject};
  SLDataSink audioSnk = {&loc_outmix, NULL};

  // create audio player
  const SLInterfaceID ids1[] = {SL_IID_ANDROIDSIMPLEBUFFERQUEUE};
  const SLboolean req1[] = {SL_BOOLEAN_TRUE};
  result = (*params->engineEngine)->CreateAudioPlayer(params->engineEngine, &(params->bqPlayerObject), &audioSrc, &audioSnk,
						      1, ids1, req1);
  if(result != SL_RESULT_SUCCESS) goto end_openaudio;

  // realize the player
  result = (*params->bqPlayerObject)->Realize(params->bqPlayerObject, SL_BOOLEAN_FALSE);
  if(result != SL_RESULT_SUCCESS) goto end_openaudio;

  // get the play interface
  result = (*params->bqPlayerObject)->GetInterface(params->bqPlayerObject, SL_IID_PLAY, &(params->bqPlayerPlay));
  if(result != SL_RESULT_SUCCESS) goto end_openaudio;

  // get the buffer queue interface
  result = (*params->bqPlayerObject)->GetInterface(params->bqPlayerObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE,
						   &(params->bqPlayerBufferQueue));
  if(result != SL_RESULT_SUCCESS) goto end_openaudio;

  // register callback on the buffer queue
  result = (*params->bqPlayerBufferQueue)->RegisterCallback(params->bqPlayerBufferQueue, bqPlayerCallback, params);
  if(result != SL_RESULT_SUCCESS) goto end_openaudio;

  // set the player's state to playing
  result = (*params->bqPlayerPlay)->SetPlayState(params->bqPlayerPlay, SL_PLAYSTATE_PLAYING);

  if((params->playBuffer = (short *) calloc(params->outBufSamples, sizeof(short))) == NULL) {
    return -1;
  }
  memset(params->playBuffer, 0, params->outBufSamples*sizeof(short));
  (*params->bqPlayerBufferQueue)->Enqueue(params->bqPlayerBufferQueue, 
    params->playBuffer,params->outBufSamples*sizeof(short));
 
 end_openaudio:
  return result;
}

int openSLInitOutParams(open_sl_params *params){
  CSOUND *csound = params->csound;
  params->outBufSamples  = csound->GetOutputBufferSize(csound);
  if((params->outputBuffer = (MYFLT *) calloc(params->outBufSamples, sizeof(MYFLT))) == NULL){
    csound->Message(csound, "memory allocation failure in opensl module \n");
    goto err_return;
  }
  if((params->outcb = csoundCreateCircularBuffer(csound, params->outParm.bufSamp_HW*csound->GetNchnls(csound), sizeof(MYFLT))) == NULL) {
    return -1; 
  }
  memset(params->outputBuffer, 0, params->outBufSamples*sizeof(MYFLT));
  return OK;

 err_return:
  return -1;  
}

/* open for audio output */
int androidplayopen_(CSOUND *csound, const csRtAudioParams *parm)
{

  CSOUND *p = csound;
  open_sl_params *params;
  int returnVal;

  params = (open_sl_params*) p->QueryGlobalVariable(p, "_openslGlobals");
  if (params == NULL) {
    if (p->CreateGlobalVariable(p, "_openslGlobals", sizeof(open_sl_params))
	!= 0)
      return -1;
    params = (open_sl_params*) p->QueryGlobalVariable(p, "_openslGlobals");
    memset(params, 0, sizeof(open_sl_params));
    params->csound = p;
    if(openSLCreateEngine(params) != SL_RESULT_SUCCESS) {
      csound->Message(csound, Str("OpenSL: engine create error \n")); 
      return -1;
    }   
  }
    
  memcpy(&(params->outParm), parm, sizeof(csRtAudioParams));
  *(p->GetRtPlayUserData(p)) = (void*) params;
    
  returnVal = openSLInitOutParams(params);
  if(openSLPlayOpen(params) !=  SL_RESULT_SUCCESS) 
      returnVal = -1;
  
  return returnVal;
}
// ===============================

// this callback handler is called every time a buffer finishes recording
void bqRecorderCallback(SLAndroidSimpleBufferQueueItf bq, void *context)
{
  open_sl_params *p = (open_sl_params *) context;
  CSOUND *csound = p->csound;
  int nchnls = csound->GetNchnls(csound);
  int items = p->inBufSamples/nchnls,i,k,n;
  MYFLT *inputBuffer = p->inputBuffer;
  short *recBuffer = p->recBuffer;
  /* convert mono to stereo */
  for(i=n=0; i < items; i++, n+=nchnls) {
    for(k=0; k < nchnls; k++)
      inputBuffer[n+k] = recBuffer[i]*CONVMYFLT;
  }
  csound->WriteCircularBuffer(csound,p->incb,p->inputBuffer,items*nchnls);
  (*p->recorderBufferQueue)->Enqueue(p->recorderBufferQueue, recBuffer,items*sizeof(short));
}

/* get samples from ADC */
int androidrtrecord_(CSOUND *csound, MYFLT *buffer, int nbytes)
{
  open_sl_params *p;
  int n = nbytes/sizeof(MYFLT);
  int m = 0, l;
  p = (open_sl_params *) *(csound->GetRtRecordUserData(csound));
  do{
    l = csound->ReadCircularBuffer(csound,p->incb,&buffer[m],n); 
    m += l;
    n -= l; 
  } while(n);
  return nbytes;
}

int openSLRecOpen(open_sl_params *params){

  SLresult result;
  SLuint32 sr = params->inParm.sampleRate;
  CSOUND *csound = params->csound;
  int nchnls;
  switch(sr){

  case 8000:
    sr = SL_SAMPLINGRATE_8;
    break;
  case 11025:
    sr = SL_SAMPLINGRATE_11_025;
    break;
  case 16000:
    sr = SL_SAMPLINGRATE_16;
    break;
  case 22050:
    sr = SL_SAMPLINGRATE_22_05;
    break;
  case 24000:
    sr = SL_SAMPLINGRATE_24;
    break;
  case 32000:
    sr = SL_SAMPLINGRATE_32;
    break;
  case 44100:
    sr = SL_SAMPLINGRATE_44_1;
    break;
  case 48000:
    sr = SL_SAMPLINGRATE_48;
    break;
  case 64000:
    sr = SL_SAMPLINGRATE_64;
    break;
  case 88200:
    sr = SL_SAMPLINGRATE_88_2;
    break;
  case 96000:
    sr = SL_SAMPLINGRATE_96;
    break;
  case 192000:
    sr = SL_SAMPLINGRATE_192;
    break;
  default:
    return -1;
  }
  nchnls = 1; /* always mono for the moment // params->csound->GetNchnls(params->csound); */
  // configure audio source
  SLDataLocator_IODevice loc_dev = {SL_DATALOCATOR_IODEVICE, SL_IODEVICE_AUDIOINPUT,
				    SL_DEFAULTDEVICEID_AUDIOINPUT, NULL};
  SLDataSource audioSrc = {&loc_dev, NULL};

  // configure audio sink
  SLDataLocator_AndroidSimpleBufferQueue loc_bq = {SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 2};
  SLDataFormat_PCM format_pcm = {SL_DATAFORMAT_PCM,nchnls, sr,
				 SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16,
				 SL_SPEAKER_FRONT_CENTER, SL_BYTEORDER_LITTLEENDIAN};
  SLDataSink audioSnk = {&loc_bq, &format_pcm};

  // create audio recorder
  // (requires the RECORD_AUDIO permission)
  const SLInterfaceID id[1] = {SL_IID_ANDROIDSIMPLEBUFFERQUEUE};
  const SLboolean req[1] = {SL_BOOLEAN_TRUE};
  result = (*params->engineEngine)->CreateAudioRecorder(params->engineEngine, &(params->recorderObject), &audioSrc,
							&audioSnk, 1, id, req);
  if (SL_RESULT_SUCCESS != result) goto end_recopen;

  // realize the audio recorder
  result = (*params->recorderObject)->Realize(params->recorderObject, SL_BOOLEAN_FALSE);
  if (SL_RESULT_SUCCESS != result) goto end_recopen;

 
  // get the record interface
  result = (*params->recorderObject)->GetInterface(params->recorderObject, SL_IID_RECORD, &(params->recorderRecord));
  if (SL_RESULT_SUCCESS != result) goto end_recopen;
 
  // get the buffer queue interface
  result = (*params->recorderObject)->GetInterface(params->recorderObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE,
						   &(params->recorderBufferQueue));
  if (SL_RESULT_SUCCESS != result) goto end_recopen;

  // register callback on the buffer queue
  result = (*params->recorderBufferQueue)->RegisterCallback(params->recorderBufferQueue, bqRecorderCallback,
							    params);
  if (SL_RESULT_SUCCESS != result) goto end_recopen;

  result = (*params->recorderRecord)->SetRecordState(params->recorderRecord, SL_RECORDSTATE_RECORDING);

  if((params->recBuffer = (short *) calloc(params->inBufSamples, sizeof(short))) == NULL) {
    return -1;
  }
  memset(params->recBuffer, 0, params->inBufSamples*sizeof(short));
  (*params->recorderBufferQueue)->Enqueue(params->recorderBufferQueue, 
					  params->recBuffer, params->inBufSamples*sizeof(short)/csound->GetNchnls(csound));
 end_recopen: 
  return result;
}

int openSLInitInParams(open_sl_params *params){
  CSOUND *csound = params->csound;
  params->inBufSamples  = csound->GetInputBufferSize(csound);
  if((params->inputBuffer = (MYFLT *)calloc(params->inBufSamples, sizeof(MYFLT))) == NULL){
    csound->Message(params->csound, "memory allocation failure in opensl module \n");
    return -1;
  }
  memset(params->inputBuffer, 0, params->inBufSamples*sizeof(MYFLT));
  if((params->incb = csoundCreateCircularBuffer(csound,params->inParm.bufSamp_HW*csound->GetNchnls(csound), sizeof(MYFLT)))== NULL) {
    return -1;
  }

  return OK;

}
/* open for audio input */
int androidrecopen_(CSOUND *csound, const csRtAudioParams *parm)
{
  CSOUND *p = csound; 
  int returnVal;
  open_sl_params *params;
  params = (open_sl_params*) p->QueryGlobalVariable(p, "_openslGlobals");
  if (params == NULL) {
    if (p->CreateGlobalVariable(p, "_openslGlobals", sizeof(open_sl_params))
	!= 0)
      return -1;
    params = (open_sl_params*) p->QueryGlobalVariable(p, "_openslGlobals");
    memset(params, 0, sizeof(open_sl_params));
    params->csound = p;
      
    if(openSLCreateEngine(params) != SL_RESULT_SUCCESS) {
      csound->Message(csound, Str("OpenSL: engine create error \n")); 
      return -1;
    } 
  }
  memcpy(&(params->inParm), parm, sizeof(csRtAudioParams));
  *(p->GetRtRecordUserData(p)) = (void*) params;
  returnVal = openSLInitInParams(params);
  if(openSLRecOpen(params) !=  SL_RESULT_SUCCESS) {
    csound->Message(csound, Str("OpenSL: input open error \n")); 
    returnVal = -1;
  }
  return returnVal;
}

/* close the I/O device entirely */
void androidrtclose_(CSOUND *csound)
{
 
  open_sl_params *params;
  params = (open_sl_params *) csound->QueryGlobalVariable(csound,
							  "_openslGlobals");
  if (params == NULL)
    return;

  // destroy buffer queue audio player object, and invalidate all associated interfaces
  if (params->bqPlayerObject != NULL) {
    SLuint32 state = SL_PLAYSTATE_PLAYING;
    (*params->bqPlayerPlay)->SetPlayState(params->bqPlayerPlay, SL_PLAYSTATE_STOPPED);
    while(state != SL_PLAYSTATE_STOPPED)
      (*params->bqPlayerPlay)->GetPlayState(params->bqPlayerPlay, &state);
    (*params->bqPlayerObject)->Destroy(params->bqPlayerObject);
    params->bqPlayerObject = NULL;
    params->bqPlayerPlay = NULL;
    params->bqPlayerBufferQueue = NULL;
    params->bqPlayerEffectSend = NULL;
  }

  // destroy audio recorder object, and invalidate all associated interfaces
  if (params->recorderObject != NULL) {
    SLuint32 state = SL_PLAYSTATE_PLAYING;
    (*params->recorderRecord)->SetRecordState(params->recorderRecord, SL_RECORDSTATE_STOPPED);
    while(state != SL_RECORDSTATE_STOPPED)
      (*params->recorderRecord)->GetRecordState(params->recorderRecord, &state);
    (*params->recorderObject)->Destroy(params->recorderObject);
    params->recorderObject = NULL;
    params->recorderRecord = NULL;
    params->recorderBufferQueue = NULL;
  }

  // destroy output mix object, and invalidate all associated interfaces
  if (params->outputMixObject != NULL) {
    (*params->outputMixObject)->Destroy(params->outputMixObject);
    params->outputMixObject = NULL;
  }

  // destroy engine object, and invalidate all associated interfaces
  if (params->engineObject != NULL) {
    (*params->engineObject)->Destroy(params->engineObject);
    params->engineObject = NULL;
    params->engineEngine = NULL;
  }
  
  csound->DestroyCircularBuffer(csound, params->incb);
  csound->DestroyCircularBuffer(csound, params->outcb);

  if (params->outputBuffer != NULL) {
    free(params->outputBuffer);
    params->outputBuffer = NULL;
  }

  if (params->inputBuffer != NULL) {
    free(params->inputBuffer);
    params->inputBuffer = NULL;
  }

  if (params->playBuffer != NULL) {
    free(params->playBuffer);
    params->playBuffer = NULL;
  }

  if (params->recBuffer != NULL) {
    free(params->recBuffer);
    params->recBuffer = NULL;
  }
     
  *(csound->GetRtRecordUserData(csound)) = NULL;
  *(csound->GetRtPlayUserData(csound)) = NULL;
  csound->DestroyGlobalVariable(csound, "_openslGlobals");

}


