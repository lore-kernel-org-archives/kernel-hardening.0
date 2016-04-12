Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160412174607.GA92143@davidb.org>
References: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>
	<20160412174607.GA92143@davidb.org>
Date: Tue, 12 Apr 2016 11:27:52 -0700
Message-ID: <CAGXu5jKPqkG52ckYAJPscySfyg+YHEVsMvPq-05YM4A3Ypx4Kg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v6 0/6] Introduce GCC plugin infrastructure
To: David Brown <david.brown@linaro.org>, Emese Revfy <re.emese@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 12, 2016 at 10:46 AM, David Brown <david.brown@linaro.org> wrote:
> On Thu, Apr 07, 2016 at 11:10:23PM +0200, Emese Revfy wrote:
>>
>> This patch set introduce the GCC plugin infrastructure with examples for
>> testing
>> and documentation.
>>
>> GCC plugins are loadable modules that provide extra features to the
>> compiler.
>> They are useful for runtime instrumentation and static analysis.
>>
>> The infrastructure supports all gcc versions from 4.5 to 6.0, building
>> out-of-tree modules and building in a separate directory.
>> Cross-compilation
>> is supported too but currently only the x86, arm and arm64 architectures
>> enables plugins.
>>
>> This infrastructure was ported from grsecurity/PaX. It is a CII project
>> supported by the Linux Foundation.
>>
>> Emese Revfy (6):
>> Shared library support
>> GCC plugin infrastructure
>> The GCC plugin infrastructure supports the arm and arm64 architectures too
>> Add Cyclomatic complexity plugin
>> Documentations of the GCC plugin infrastructre
>> Add sancov plugin
>
>
> I've tested the v6 patches on arm, and partially on arm64.  The arm64
> gcc has a bug in make install that doesn't install all necessary
> headers to build plugins.  I believe the patch will work once that
> version gets out.  It does, however, print a helpful message now
> explaining the likely cause of the failure.
>
> Tested-by: David Brown <david.brown@linaro.org>

Awesome! Thanks for testing this. I still need to finish getting my
arm64 environment built...

Do you happen to know if there's already a gcc bug open for the make
install problem?

Masahiro and Michal, does this series look good to you? I'd really
like to get this into -next for wider testing.

Emese, were you thinking of doing the initify plugin next after this
infrastructure lands?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
