Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH v2 04/20] fork: provide a function for copying init_mm
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190205085311.GH21801@zn.tnic>
Date: Tue, 5 Feb 2019 01:03:45 -0800
Content-Transfer-Encoding: 7bit
Message-Id: <BF9D1501-5EFF-46FB-8DAB-8C7A2088DB42@gmail.com>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-5-rick.p.edgecombe@intel.com>
 <20190205085311.GH21801@zn.tnic>
To: Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Feb 5, 2019, at 12:53 AM, Borislav Petkov <bp@alien8.de> wrote:
> 
> On Mon, Jan 28, 2019 at 04:34:06PM -0800, Rick Edgecombe wrote:
>> From: Nadav Amit <namit@vmware.com>
>> 
>> - * Allocate a new mm structure and copy contents from the
>> - * mm structure of the passed in task structure.
>> +/**
>> + * dup_mm() - duplicates an existing mm structure
>> + * @tsk: the task_struct with which the new mm will be associated.
>> + * @oldmm: the mm to duplicate.
>> + *
>> + * Allocates a new mm structure and copy contents from the provided
> 
> s/copy/copies/

Thanks, applied (I revised this sentence a bit).
