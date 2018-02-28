Date: Wed, 28 Feb 2018 11:34:00 +0530 (IST)
From: P J P <ppandit@redhat.com>
Subject: Re: [PATCH 0/1] Zero initialise kernel stack variables
In-Reply-To: <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
Message-ID: <nycvar.YSQ.7.76.1802281122170.21989@wniryva>
References: <20180227111532.1144-1-ppandit@redhat.com> <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

  Hello Kees, Laura,

Thank you so much for the kind review, I appreciate it.

+-- On Tue, 27 Feb 2018, Kees Cook wrote --+
| Unfortunately "noticeable" isn't going to be a viable metric. You'll need to 
| do some real-world benchmarks (i.e. kernel builds, hackbench, etc), and 
| compare the results.

  Yes, okay. I'll do this exercise and get back with the results.

| Even just initializing passed-by-reference variables 
| (GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) had measurable performance impact.

  I see.
 
| It would be nice to have four options/features available from the
| compiler, from least to most performance impact:
| 
| - initialize padding to zero when static initializers are used (this would 
|   make foo = { .field = something }; identical to memset(&foo, 0, 
|   sizeof(foo)); foo.field = something for all structures, but now, any 
|   structures with padding _must_ use the latter to be safe, which is highly 
|   error-prone).
| 
| - initialize all uninitialized variables that contain a structure marked 
|   with a special attribute (e.g.  __attribute__((force_initialize)) ).
| 
| - initialize all uninitialized variables that are passed by reference (see 
|   GCC_PLUGIN_STRUCTLEAK_BYREF_ALL).
| 
| - initialize all uninitialized variables (-finit-local-vars seems to do 
|   this)

  I see, will check about these.
 
| > The patch here adds a kbuild menu option to enable/disable '-finit-local-vars'
| > compiler flag while building the Linux kernel.
| 
| Since this is a single patch, I think it'd be better to fold this
| entire cover letter into patch 1.

  Right, okay.

Thank you so much.
--
Prasad J Pandit / Red Hat Product Security Team
47AF CE69 3A90 54AA 9045 1053 DD13 3D32 FE5B 041F
