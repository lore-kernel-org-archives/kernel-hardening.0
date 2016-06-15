Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160615225331.abb990e0302757ea9a6a3500@gmail.com>
References: <20160524000719.b456ed0cd2aafacb4e53f177@gmail.com>
 <20160524001035.081cbf822a62b274ad945dc1@gmail.com> <041e2196-2213-725d-64aa-8526b23bc618@redhat.com>
 <20160615225331.abb990e0302757ea9a6a3500@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 15 Jun 2016 15:41:28 -0700
Message-ID: <CAGXu5jL4sq1zibXqg1KsoRQfdfyB5K_-6+GGL=kKOSWUXNxoUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v9 3/4] Add Cyclomatic complexity GCC plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 1:53 PM, Emese Revfy <re.emese@gmail.com> wrote:
> On Tue, 14 Jun 2016 12:29:59 -0700
> Laura Abbott <labbott@redhat.com> wrote:
>
>> On 05/23/2016 03:10 PM, Emese Revfy wrote:
>> 1) make mrproper
>> 2) make defconfig
>> 3) enable GCC_PLUGINS, GCC_PLUGIN_CYC_COMPLEXITY
>> 4) enable FUNCTION_TRACER (it will select other options as well)
>> 5) make && make modules
>>
>> ERROR: "__fentry__" [net/ipv4/netfilter/ipt_MASQUERADE.ko] undefined!
>> ERROR: "__fentry__" [fs/efivarfs/efivarfs.ko] undefined!
>> ERROR: "__fentry__" [drivers/thermal/x86_pkg_temp_thermal.ko] undefined!
>> scripts/Makefile.modpost:91: recipe for target '__modpost' failed
>> make[1]: *** [__modpost] Error 1
>
> The patch below fixes this bug, but I think it is ugly.
> https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next/commit/73e2d117daa7f3c6aee8935ecbb318354ff9cd82
>
> If anyone has a better idea to fix this, please let me know.

I think the logic looks fine, but I think I would name it more
generically. For example, call it something plugin-agnostic like
KBUILD_CFLAGS_MINIMUM.

I actually wonder if I can use this same logic to fix the stack
protector detection code...

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
