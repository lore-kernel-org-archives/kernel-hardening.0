Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 15 Apr 2016 11:20:10 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160415092010.GB10167@gmail.com>
References: <20160412221659.GA18102@www.outflux.net>
 <20160414200102.GB3856@amd>
 <CAGXu5jKNKV2RaPCw+m3R-e7irmmP0eRBBq9RKY0mcH5A1Nsx6g@mail.gmail.com>
 <20160414203444.GC3856@amd>
 <CAGXu5j+cTYF_OGG=u4BKU5X3f6TF0FdAcES9e_8S0ajMyjhn6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+cTYF_OGG=u4BKU5X3f6TF0FdAcES9e_8S0ajMyjhn6Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2] kaslr: allow kASLR to be default over Hibernation
To: Kees Cook <keescook@chromium.org>
Cc: Pavel Machek <pavel@denx.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> 1) The x86 hibernation and KASLR code don't play well together currently.

Please fix it, don't just work it around ...

Thanks,

	Ingo
