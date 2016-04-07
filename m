Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 7 Apr 2016 02:49:58 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160407004958.GA27130@gmail.com>
References: <20160406194404.GA11150@www.outflux.net>
 <20160406201716.GA14241@amd>
 <CA+55aFw+JFfy+dfMbAdB3ueA1O-w--EBwMF4WKrGp754trHBDA@mail.gmail.com>
 <CAGXu5jJ+8v_hMkV91jqNGwFdzbpoKL=gZv-92hGMF8d4o8DswQ@mail.gmail.com>
 <20160406214835.GA23620@gmail.com>
 <20160406215240.GA25339@gmail.com>
 <CAJZ5v0h4uShH_r6=osGYZ_ZH_qjL7KufnEiZ8auHQhKRzRyC1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0h4uShH_r6=osGYZ_ZH_qjL7KufnEiZ8auHQhKRzRyC1Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] Prefer kASLR over Hibernation
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@denx.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Rafael J. Wysocki <rafael@kernel.org> wrote:

> [...]
> 
> One of the weak points is the final jump, because it has to be done to the 
> physical location of the image kernel's entry point even though the virtual 
> addresses of it may differ between the boot and the image kernels.  The seed is 
> not needed for that, only the physical address of the entry point.  The boot 
> kernel doesn't have it today, though, because the virtual address of that is 
> passed in the image header. That should not be too difficult to change, however.

I didn't realize we jumped to the image kernel as well - I (wrongly) assumed we 
kept the bootup kernel. That should indeed make hibernation mostly 
kASLR-invariant.

Thanks,

	Ingo
