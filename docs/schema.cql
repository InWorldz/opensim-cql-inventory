/*
Copyright (c) 2014, InWorldz, LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of opensim-cql-inventory nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/*
  This is a sample CQL schema for opensimulator inventory. The primary item
  storage is designed around a few facts of how inventory retrieval works:

  1) SL based viewers don't request subfolders directly during inventory fetch.
  Even though it appears this facility is available, the viewer retrieves all
  the folders in the entire inventory tree on login from what is called the
  "skeleton"

  2) All items from a folder are requested at once. Therefore, we want to
  optimize reads for this case and not turn every individual item into an IO
  during inventory download.

  3) Items are rezzed by their ID. It looks like a folder ID is sent along for
  the ride, but in tests run in the past this ID was null. This means we need
  to map item IDs back to their parent folder ID.

  4) All folders have version numbers that get incremented when items or
  subfolders are changed, created, moved or deleted. Since this is a simple
  increment we'll use a counter column on the skeleton to handle the
  bookkeeping.
*/