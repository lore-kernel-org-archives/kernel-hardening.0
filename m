MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180717071223.GA29533@gmail.com>
References: <CA+55aFyeZGaC7DSYT6oKuC+Pdpx1Jd95wC97XFdZdNPqD325RA@mail.gmail.com>
 <20180712135944.GB6199@gmail.com> <CAGXu5jJQ2EWKsEWcDf3WWv94kYDcubCSVHA_YhG0HKG+XbahFQ@mail.gmail.com>
 <20180712205016.GA20649@gmail.com> <50c690fc-c967-8376-8524-ac9c1be722bc@linux.com>
 <CAGXu5j+Vc3U6C3UO1CVYN+EmguJdoPCuatOJ2vpAx=r1jbmwjQ@mail.gmail.com>
 <20180715224446.GA29087@gmail.com> <ae9db092-13fa-101c-1d07-5767631f7611@linux.com>
 <20180716101337.GA30279@gmail.com> <7e673919-4c6a-0120-a198-a0ed4ee47b36@linux.com>
 <20180717071223.GA29533@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 17 Jul 2018 12:58:04 -0700
Message-ID: <CAGXu5jLo3e_UsHjqUaApeS5vdZ37ogqUREpZf2Zi_QdYCttMJw@mail.gmail.com>
Subject: Re: [PATCH v14 0/6] Introduce the STACKLEAK feature and a test for it
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Popov <alex.popov@linux.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Pax Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andrew Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V. Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nick Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>, dingtianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 17, 2018 at 12:12 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Alexander Popov <alex.popov@linux.com> wrote:
>> Thanks, I see your point.
>> I'll return with an additional patch introducing sysctl knob + static key for
>> one-time disabling of stack erasing.
>
> Thank you!
>
> I'll have a final review of the patch but I guess it will be fine, so if that's
> the only change then you can also include my:
>
>   Acked-by: Ingo Molnar <mingo@kernel.org>
>
> ... to not hold the patch up for v4.19, and this can go upstream via Kees's tree?

Thanks for your reviews, Ingo! Is this Ack for the entire series or a
specific subset?

-Kees

-- 
Kees Cook
Pixel Security
