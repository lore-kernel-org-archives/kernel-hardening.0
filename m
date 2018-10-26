Date: Fri, 26 Oct 2018 11:26:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181026092609.GB3159@worktop.c.hoisthospitality.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181023213504.28905-11-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Jon,

So the below document is a prime example for why I think RST sucks. As a
text document readability is greatly diminished by all the markup
nonsense.

This stuff should not become write-only content like html and other
gunk. The actual text file is still the primary means of reading this.

> diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
> index 26b735cefb93..1a90fa878d8d 100644
> --- a/Documentation/core-api/index.rst
> +++ b/Documentation/core-api/index.rst
> @@ -31,6 +31,7 @@ Core utilities
>     gfp_mask-from-fs-io
>     timekeeping
>     boot-time-mm
> +   prmem
>  
>  Interfaces for kernel debugging
>  ===============================
> diff --git a/Documentation/core-api/prmem.rst b/Documentation/core-api/prmem.rst
> new file mode 100644
> index 000000000000..16d7edfe327a
> --- /dev/null
> +++ b/Documentation/core-api/prmem.rst
> @@ -0,0 +1,172 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +.. _prmem:
> +
> +Memory Protection
> +=================
> +
> +:Date: October 2018
> +:Author: Igor Stoppa <igor.stoppa@huawei.com>
> +
> +Foreword
> +--------
> +- In a typical system using some sort of RAM as execution environment,
> +  **all** memory is initially writable.
> +
> +- It must be initialized with the appropriate content, be it code or data.
> +
> +- Said content typically undergoes modifications, i.e. relocations or
> +  relocation-induced changes.
> +
> +- The present document doesn't address such transient.
> +
> +- Kernel code is protected at system level and, unlike data, it doesn't
> +  require special attention.

What does this even mean?

> +Protection mechanism
> +--------------------
> +
> +- When available, the MMU can write protect memory pages that would be
> +  otherwise writable.

Again; what does this really want to say?

> +- The protection has page-level granularity.

I don't think Linux supports non-paging MMUs.

> +- An attempt to overwrite a protected page will trigger an exception.
> +- **Write protected data must go exclusively to write protected pages**
> +- **Writable data must go exclusively to writable pages**

WTH is with all those ** ?

> +Available protections for kernel data
> +-------------------------------------
> +
> +- **constant**
> +   Labelled as **const**, the data is never supposed to be altered.
> +   It is statically allocated - if it has any memory footprint at all.
> +   The compiler can even optimize it away, where possible, by replacing
> +   references to a **const** with its actual value.
> +
> +- **read only after init**
> +   By tagging an otherwise ordinary statically allocated variable with
> +   **__ro_after_init**, it is placed in a special segment that will
> +   become write protected, at the end of the kernel init phase.
> +   The compiler has no notion of this restriction and it will treat any
> +   write operation on such variable as legal. However, assignments that
> +   are attempted after the write protection is in place, will cause
> +   exceptions.
> +
> +- **write rare after init**
> +   This can be seen as variant of read only after init, which uses the
> +   tag **__wr_after_init**. It is also limited to statically allocated
> +   memory. It is still possible to alter this type of variables, after
> +   the kernel init phase is complete, however it can be done exclusively
> +   with special functions, instead of the assignment operator. Using the
> +   assignment operator after conclusion of the init phase will still
> +   trigger an exception. It is not possible to transition a certain
> +   variable from __wr_ater_init to a permanent read-only status, at
> +   runtime.
> +
> +- **dynamically allocated write-rare / read-only**
> +   After defining a pool, memory can be obtained through it, primarily
> +   through the **pmalloc()** allocator. The exact writability state of the
> +   memory obtained from **pmalloc()** and friends can be configured when
> +   creating the pool. At any point it is possible to transition to a less
> +   permissive write status the memory currently associated to the pool.
> +   Once memory has become read-only, it the only valid operation, beside
> +   reading, is to released it, by destroying the pool it belongs to.

Can we ditch all the ** nonsense and put whitespace in there? More paragraphs
and whitespace are more good.

Also, I really don't like how you differentiate between static and
dynamic wr.

> +Protecting dynamically allocated memory
> +---------------------------------------
> +
> +When dealing with dynamically allocated memory, three options are
> + available for configuring its writability state:
> +
> +- **Options selected when creating a pool**
> +   When creating the pool, it is possible to choose one of the following:
> +    - **PMALLOC_MODE_RO**
> +       - Writability at allocation time: *WRITABLE*
> +       - Writability at protection time: *NONE*
> +    - **PMALLOC_MODE_WR**
> +       - Writability at allocation time: *WRITABLE*
> +       - Writability at protection time: *WRITE-RARE*
> +    - **PMALLOC_MODE_AUTO_RO**
> +       - Writability at allocation time:
> +           - the latest allocation: *WRITABLE*
> +           - every other allocation: *NONE*
> +       - Writability at protection time: *NONE*
> +    - **PMALLOC_MODE_AUTO_WR**
> +       - Writability at allocation time:
> +           - the latest allocation: *WRITABLE*
> +           - every other allocation: *WRITE-RARE*
> +       - Writability at protection time: *WRITE-RARE*
> +    - **PMALLOC_MODE_START_WR**
> +       - Writability at allocation time: *WRITE-RARE*
> +       - Writability at protection time: *WRITE-RARE*

That's just unreadable gibberish from here. Also what?

We already have RO, why do you need more RO?

> +
> +   **Remarks:**
> +    - The "AUTO" modes perform automatic protection of the content, whenever
> +       the current vmap_area is used up and a new one is allocated.
> +        - At that point, the vmap_area being phased out is protected.
> +        - The size of the vmap_area depends on various parameters.
> +        - It might not be possible to know for sure *when* certain data will
> +          be protected.

Surely that is a problem?

> +        - The functionality is provided as tradeoff between hardening and speed.

Which you fail to explain.

> +        - Its usefulness depends on the specific use case at hand

How about you write sensible text inside the option descriptions
instead?

This is not a presentation; less bullets, more content.

> +- Not only the pmalloc memory must be protected, but also any reference to
> +  it that might become the target for an attack. The attack would replace
> +  a reference to the protected memory with a reference to some other,
> +  unprotected, memory.

I still don't really understand the whole write-rare thing; how does it
really help? If we can write in kernel memory, we can write to
page-tables too.

And I don't think this document even begins to explain _why_ you're
doing any of this. How does it help?

> +- The users of rare write must take care of ensuring the atomicity of the
> +  action, respect to the way they use the data being altered; for example,
> +  take a lock before making a copy of the value to modify (if it's
> +  relevant), then alter it, issue the call to rare write and finally
> +  release the lock. Some special scenario might be exempt from the need
> +  for locking, but in general rare-write must be treated as an operation
> +  that can incur into races.

What?!
