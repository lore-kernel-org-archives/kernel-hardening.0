MIME-Version: 1.0
References: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
In-Reply-To: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jul 2018 13:53:00 -0700
Message-ID: <CA+55aFyeZGaC7DSYT6oKuC+Pdpx1Jd95wC97XFdZdNPqD325RA@mail.gmail.com>
Subject: Re: [PATCH v14 0/6] Introduce the STACKLEAK feature and a test for it
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Pax Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andrew Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V. Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nick Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>, dingtianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 11, 2018 at 1:37 PM Alexander Popov <alex.popov@linux.com> wrote:
>
> This is the 14th version of the patch series introducing STACKLEAK
> to the mainline kernel for x86. This version comes with style changes
> according to the feedback from Ingo Molnar and includes Laura Abbott's
> modifications of scripts/Makefile.gcc-plugins.

As before, I will repeat that I think 1% on a kernel compile (which
has almost no actual kernel footprint) is a huge cost, and other -
more kernel-centric - loads will likely see much worse performance.

And I still think that this is stupid, and peoples time would be
*much* better spent on plugins that have much lower costs and get
pretty much the same advanytages (ie the whole "just initialize all
automatics to zero" thing or similar).

But whatever. I'll just continue to tell people not to use silly
config options that have a high cost-to-point ratio. If people *want*
to waste their CPU, that's their problem.

                    Linus
