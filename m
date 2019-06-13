Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <54a4d14c-b19b-339e-5a15-adb10297cb30@amazon.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <7b17ff38-b505-74c6-d773-8ab5e000be10@intel.com>
Date: Thu, 13 Jun 2019 07:19:02 -0700
MIME-Version: 1.0
In-Reply-To: <54a4d14c-b19b-339e-5a15-adb10297cb30@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Alexander Graf <graf@amazon.com>, Marius Hillenbrand <mhillenb@amazon.de>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6/13/19 12:27 AM, Alexander Graf wrote:
>> Where's the context-switching code?  Did I just miss it?
> 
> I'm not sure I understand the question. With this mechanism, the global
> linear map pages are just not present anymore, so there is no context
> switching needed. For the process local memory, the page table is
> already mm local, so we don't need to do anything special during context
> switch, no?

Thanks for explaining, I was just confused.

Andy reminded me when comparing it to the LDT area: since this area is
per-mm/pgd and we context switch that *obviously* there's no extra work
to do at context switch time, as long as the area is marked non-Global.
