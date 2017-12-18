From: Igor Stoppa <igor.stoppa@huawei.com>
Date: Mon, 18 Dec 2017 23:33:39 +0200
Message-ID: <20171218213340.24325-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [RFC PATCH 0/1] genalloc: track beginning of allocations
To: mhocko@kernel.org, labbott@redhat.com, jes@trained-monkey.org, ying.huang@intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Igor Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

genalloc could be improved, to know how to separate the memory use by
adjacent allocations

This patch is generated from the effort of introducing in the kernel an
allocator for protectable memory (pmalloc).

However, it seems that the patch could have a value of its own.
It can:
- verify that the freeing of memory is consistent with previous allocations
- relieve the user of the API from tracking the size of each allocation
- enable use cases where generic code can free memory allocations received
  through a pointer (provided that the reference pool is known)

Details about the implementation are provided in the comment for the patch.

I mentioned this idea few months ago, as part of the pmalloc discussion,
but then I did not have time to follow-up immediately, as I had hoped.

This is an implementation of what I had in mind.
It seems to withstand several simple test cases i put together, but it
definitely would need thorough review.


I hope I have added as reviewer all the relevant people.
If I missed someone, please include them to the recipients.


Igor Stoppa (1):
  genalloc: track beginning of allocations

 include/linux/genalloc.h |   3 +-
 lib/genalloc.c           | 417 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 289 insertions(+), 131 deletions(-)

-- 
2.9.3
