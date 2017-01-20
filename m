MIME-Version: 1.0
In-Reply-To: <20170120164126.27624-1-thgarnie@google.com>
References: <20170120164126.27624-1-thgarnie@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 20 Jan 2017 14:24:42 -0800
Message-ID: <CALCETrVt38oa6C+-JD1B+4wXnkB8ySUksZ55k0+Bz4dbusYWDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/3] x86/mm: Adapt MODULES_END based on Fixmap section size
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Chen Yucong <slaoub@gmail.com>, Baoquan He <bhe@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 20, 2017 at 8:41 AM, Thomas Garnier <thgarnie@google.com> wrote:
> This patch aligns MODULES_END to the beginning of the Fixmap section.
> It optimizes the space available for both sections. The address is
> pre-computed based on the number of pages required by the Fixmap
> section.
>
> It will allow GDT remapping in the Fixmap section. The current
> MODULES_END static address does not provide enough space for the kernel
> to support a large number of processors.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Looks good to me.
