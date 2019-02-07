Date: Thu, 7 Feb 2019 12:49:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 16/17] Plug in new special vfree flag
Message-ID: <20190207124949.0ea219a7@gandalf.local.home>
In-Reply-To: <16a2ac45ceef5b6f310f816d696ad2ea8df3b45c.camel@intel.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
	<20190117003259.23141-17-rick.p.edgecombe@intel.com>
	<20190206112356.64cc5f0d@gandalf.local.home>
	<16a2ac45ceef5b6f310f816d696ad2ea8df3b45c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jeyu@kernel.org" <jeyu@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "luto@kernel.org" <luto@kernel.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "bp@alien8.de" <bp@alien8.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>, "ast@kernel.org" <ast@kernel.org>, "paulmck@linux.ibm.com" <paulmck@linux.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 7 Feb 2019 17:33:37 +0000
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:


> > > ---
> > >  arch/x86/kernel/ftrace.c       |  6 +--  
> > 
> > For the ftrace code.
> > 
> > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > 
> > -- Steve
> >   
> Thanks!

I just noticed that the subject is incorrect; It is missing the
"subsystem:" part. See Documentation/process/submitting-patches.rst

-- Steve
