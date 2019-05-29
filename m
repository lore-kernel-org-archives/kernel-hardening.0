MIME-Version: 1.0
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-12-thgarnie@chromium.org>
 <1b53b8eb-5dd3-fb57-d8db-06eedd0ce49f@suse.com>
In-Reply-To: <1b53b8eb-5dd3-fb57-d8db-06eedd0ce49f@suse.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Wed, 29 May 2019 08:48:32 -0700
Message-ID: <CAJcbSZF1xcMpLDrOLkh493+ciVUqrku9WkWdb5xxAqWuXMjGZw@mail.gmail.com>
Subject: Re: [PATCH v7 11/12] x86/paravirt: Adapt assembly for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Juergen Gross <jgross@suse.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, virtualization@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, May 26, 2019 at 10:47 PM Juergen Gross <jgross@suse.com> wrote:
>
> On 21/05/2019 01:19, Thomas Garnier wrote:
> > From: Thomas Garnier <thgarnie@google.com>
> >
> > if PIE is enabled, switch the paravirt assembly constraints to be
> > compatible. The %c/i constrains generate smaller code so is kept by
> > default.
> >
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
> >
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
>
> Acked-by: Juergen Gross <jgross@suse.com>

Thanks Juergen.

>
>
> Juergen
