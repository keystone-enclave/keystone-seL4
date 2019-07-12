//******************************************************************************
// Copyright (c) 2018, The Regents of the University of California (Regents).
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------
#include "keystone.h"
#include "edge_call.h"
int main(int argc, char** argv)
{
  Keystone enclave;
  Params params;

  params.setFreeMemSize(512*1024*1024);
  params.setUntrustedMem(0x40000000, 1024);

  enclave.init(argv[1], argv[2], params);

  enclave.run();

  return 0;
}
