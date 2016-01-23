Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <CAGXu5j+5EB5f335RHOP+CugFC1z29cAV0pWy6zB34dQBz7W6_Q@mail.gmail.com>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
	<20160122171954.GA3945@davidb.org>
	<56A28029.2060608@labbott.name>
	<CAGXu5j+5EB5f335RHOP+CugFC1z29cAV0pWy6zB34dQBz7W6_Q@mail.gmail.com>
Date: Sat, 23 Jan 2016 10:49:15 +0100
Message-ID: <CAMuHMdW46hT9usJ-UxAnSKqzTdHfV+VKzU-L9O2NkSegTfbn9Q@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v4 0/8] introduce post-init read-only memory
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <laura@labbott.name>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Fri, Jan 22, 2016 at 8:57 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jan 22, 2016 at 11:16 AM, Laura Abbott <laura@labbott.name> wrote:
>> Kees had previously pushed a patch to do so but it exposed a couple of
>> underlying issues, mostly with low power paths
>> (c.f. http://article.gmane.org/gmane.linux.ports.arm.kernel/471199,
>> http://article.gmane.org/gmane.linux.kernel.mm/143489)
>> Those will need to be all fixed up before this could be made default.

I'm working on fixing that...

BTW, making the sections read-only is done quite late in the kernel startup
process, which means it doesn't trigger for the writes to the text segment in
secondary CPU bringup, but only for suspend/resume.

> Yeah, I've got a patch waiting to reorganize CONFIG_ARM_KERNMEM_PERMS
> to look more like arm64 (and x86) and get the feature correctly under
> CONFIG_DEBUG_RODATA. I made it default=y on v7+. rmk asked me to wait
> until -rc1 before resubmitting it.
>
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=kspp/arm-rodata&id=08bebfd2e7fb8a9f364ced74c356642d64e1f43e

One other concern is indeed memory usage ("ALIGN(1<<SECTION_SHIFT)"?).
Enabling CONFIG_ARM_KERNMEM_PERMS and CONFIG_DEBUG_RODATA in my test kernel
configs make the kernel too big to boot (overwritten DTB?) for 3 out of 4 arm
shmobile targets...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
