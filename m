Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 21 Apr 2013 11:13:42 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130421091342.GD31470@gmail.com>
References: <20130419231638.GA20133@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130419231638.GA20133@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH] x86: kaslr: move ELF relocation handling to C
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, x86@kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Jiri Kosina <jkosina@suse.cz>, Olaf Hering <olaf@aepfle.de>, Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Gokul Caushik <caushik1@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Joe Millenbach <jmillenbach@gmail.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Jacob Shin <jacob.shin@amd.com>, Pekka Enberg <penberg@kernel.org>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> Moves the relocation handling into C, after decompression. Only
> kernels that need relocation support will use the code. The new
> CONFIG_RANDOMIZE_BASE does not yet do anything except turn on this logic
> for 64-bit kernels.

So why not keep the inactive CONFIG_RANDOMIZE_BASE hunks in a separate 
patch, and just have this one clean, orthogonal patch that moves 
relocation handling into C?

Thanks,

	Ingo
