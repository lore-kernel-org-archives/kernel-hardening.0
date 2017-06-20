MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <49abb4c2-e638-9657-f007-0c18ef6d0f28@linux.com>
References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com> <49abb4c2-e638-9657-f007-0c18ef6d0f28@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 20 Jun 2017 12:20:17 -0700
Message-ID: <CAGXu5j+S-rUQXbqyLOf2drvNvPnd1yz2VC2+UanXYo7vVTrThA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v2 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 9, 2017 at 4:00 PM, Alexander Popov <alex.popov@linux.com> wrote:
> On 09.06.2017 20:28, Kees Cook wrote:
>> Awesome, and thanks for the benchmarks! That should really help people
>> understand the trade-offs for using this feature (and is likely worth
>> mentioning in the Kconfig). Seems like less than 4% overhead, maybe
>> much less? Real time on build times seems like a tiny difference, but
>> hackbench shows 4%.
>
> Yes, the performance penalty of STACKLEAK differs a lot depending on the
> kind of load. Do you have any idea which test can give a bigger slowdown?
> It should be some rapid syscall exhausting the kernel stack hard.

I can't think of anything off the top of my head. You could play with
CONFIG_FRAME_WARN[1] and related tools to find a deep call path and
try that?

[1] http://elinux.org/Kernel_Small_Stacks

>> Maybe specifically mention the -0xBEEF value?
>
> Ok. Should I create some macro for it?

Maybe? It's not really clear how useful that might be. If it's easy,
then yeah, use a common macro for the value, if it creates header
soup, leave it open-coded.

>> I would follow the naming of the others, and call this GCC_PLUGIN_STACKLEAK
>
> It seems to me that GCC_PLUGIN_STACKLEAK is not a right name since the whole
> feature consists of two parts: the arch-specific asm code actually cleaning
> the kernel stack and the gcc plugin which helps to do it faster and more
> reliable. What do you think?

It looks like the feature requires the plugin, so I think the common
naming (GCC_PLUGIN_STACKLEAK) would be preferred. But perhaps I'm
overlooking something where the plugin is not used?

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
