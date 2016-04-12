Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 12 Apr 2016 12:41:47 -0600
From: David Brown <david.brown@linaro.org>
Message-ID: <20160412184147.GA92432@davidb.org>
References: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>
 <20160412174607.GA92143@davidb.org>
 <CAGXu5jKPqkG52ckYAJPscySfyg+YHEVsMvPq-05YM4A3Ypx4Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jKPqkG52ckYAJPscySfyg+YHEVsMvPq-05YM4A3Ypx4Kg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v6 0/6] Introduce GCC plugin infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 12, 2016 at 11:27:52AM -0700, Kees Cook wrote:

>Awesome! Thanks for testing this. I still need to finish getting my
>arm64 environment built...

I've been using:
  http://releases.linaro.org/components/toolchain/binaries/

for most stuff.

>Do you happen to know if there's already a gcc bug open for the make
>install problem?

Linaro toolchain bug:
  https://bugs.linaro.org/show_bug.cgi?id=2123

Patch to fix it
  https://gcc.gnu.org/ml/gcc-patches/2016-03/msg00522.html

It is supposed to be included in the linaro 5.3-2016.03 snapshot.
I've pinged Christophe to see if I can get any insight into when that
will be available.

It is kind of nice to see that when it fails, it prints a helpful
message, though:

  scripts/Makefile.gcc-plugins:22: *** error, your gcc installation does not support plugins, perhaps the necessary headers are missing?.  Stop.

I think it is OK to include this, even with the patches still bubbling
through gcc releases.  It prints a helpful message when it doesn't
work, and is only going to be selected if specifically requested.

David
