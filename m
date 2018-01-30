From: Igor Stoppa <igor.stoppa@huawei.com>
Subject: [LSF/MM TOPIC] Protectable Dynamically allocated Memory for both
 kernel and userspace
Message-ID: <c6c462fe-4aa1-3922-725d-03c3b1da0786@huawei.com>
Date: Tue, 30 Jan 2018 15:57:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: lsf-pc@lists.linux-foundation.org, Linux-MM <linux-mm@kvack.org>
Cc: Michal Hocko <mhocko@kernel.org>, Kees Cook <keescook@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

At the LSF/MM summit, I would like to discuss the following topics:

- Dynamic allocation of protectable (read/only) memory in kernel space
- Rare Write option for the aforementioned dynamic allocation
  (this is most likely related to Kees Cook's rare-write proposal)
- Support for userspace to mprotect selected pages:
   * as permanently R/O
   * as rare write
    (this might be easier to implement than kernel rare-write)
   Probably both of these will also require a separate userspace memory
   allocator, which understands pools, or at the very least, can support
   different types of pages.
- Optimization of vmalloc (combining vmap_area and vm_struct structures)

--
igor stoppa
