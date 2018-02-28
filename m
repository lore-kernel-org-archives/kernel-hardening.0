Date: Wed, 28 Feb 2018 11:52:58 +0530 (IST)
From: P J P <ppandit@redhat.com>
Subject: Re: [PATCH 0/1] Zero initialise kernel stack variables
In-Reply-To: <CAGXu5j+rEo9u4CoNBz+Y-HDCqX5=mv__0Wvru6tJRgri2r2BUQ@mail.gmail.com>
Message-ID: <nycvar.YSQ.7.76.1802281134110.21989@wniryva>
References: <20180227111532.1144-1-ppandit@redhat.com> <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com> <f5f8d06d-461f-f4ad-bc32-5a18f5359353@redhat.com> <CAGXu5j+rEo9u4CoNBz+Y-HDCqX5=mv__0Wvru6tJRgri2r2BUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Florian Weimer <fweimer@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

+-- On Tue, 27 Feb 2018, Kees Cook wrote --+
| On Tue, Feb 27, 2018 at 3:26 PM, Laura Abbott <labbott@redhat.com> wrote:
| > For comparison (-300 is official Fedora, -301 is from the repo):
| >
| >    text           data     bss     dec             hex  filename
| > 16948437        6771094 1777872 25497403        1850f3b /lib/debug/lib/modules/4.15.5-300.fc27.x86_64/vmlinux
| > 16970359        6776078 1777872 25524309        1857855 /lib/debug/lib/modules/4.15.5-301.fc27.x86_64/vmlinux
| 
| That's a surprisingly small text change! I'd love to see benchmarks
| too. Are you able to verify this is initializing the
| passed-by-reference variables too? Hmm, I suspect it's time for
| another LKDTM test. ;)

  It could be because I had to build Crypt target support(CONFIG_DM_CRYPT=y)
into kernel. It would not boot without it, not sure why. F27 -300 kernel does 
boot with DM_CRYPT as module.

===
$ diff -Naurp config-4.15.5-300.fc27.x86_64 config-4.15.5-301.fc27.x86_64 
--- config-4.15.5-300.fc27.x86_64       2018-02-28 11:49:52.248210900 +0530
+++ config-4.15.5-301.fc27.x86_64       2018-02-28 11:50:35.448957090 +0530
@@ -1,6 +1,6 @@
 #
 # Automatically generated file; DO NOT EDIT.
-# Linux/x86_64 4.15.5-300.fc27.x86_64 Kernel Configuration
+# Linux/x86_64 4.15.5-301.fc27.x86_64 Kernel Configuration
 #
 CONFIG_64BIT=y
 CONFIG_X86_64=y
@@ -2394,7 +2394,7 @@ CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING=y
 # CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
 CONFIG_DM_BIO_PRISON=m
 CONFIG_DM_PERSISTENT_DATA=m
-CONFIG_DM_CRYPT=m
+CONFIG_DM_CRYPT=y
 CONFIG_DM_SNAPSHOT=y
 CONFIG_DM_THIN_PROVISIONING=m
 CONFIG_DM_CACHE=m
@@ -7612,6 +7612,7 @@ CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_VTA=y
 # CONFIG_GDB_SCRIPTS is not set
 # CONFIG_ENABLE_WARN_DEPRECATED is not set
+CONFIG_FINIT_LOCAL_VARS=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_WARN=2048
 CONFIG_STRIP_ASM_SYMS=y
===

Thank you.
--
Prasad J Pandit / Red Hat Product Security Team
47AF CE69 3A90 54AA 9045 1053 DD13 3D32 FE5B 041F
