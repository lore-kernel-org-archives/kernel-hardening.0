Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <516597DB.4020208@zytor.com>
Date: Wed, 10 Apr 2013 09:48:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20130408224328.GA17641@www.outflux.net> <51634935.9010905@zytor.com> <877gkc596d.fsf@xmission.com> <20130410095716.GF24443@gmail.com> <87sj2yzn1a.fsf@xmission.com> <CAG7+5M06h_UEy39OQqdT7Z6r-85q_R9zHHKGO6F2PX2pgT6U9g@mail.gmail.com>
In-Reply-To: <CAG7+5M06h_UEy39OQqdT7Z6r-85q_R9zHHKGO6F2PX2pgT6U9g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: Eric Northup <digitaleric@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, the arch/x86 maintainers <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Xen Devel <xen-devel@lists.xensource.com>, lf-virt <virtualization@lists.linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/10/2013 09:31 AM, Eric Northup wrote:
>>
>> If the effect is measurable I agree it is a legitimate optimization.  At
>> one point there was a suggestion to make the code in the IDT vectors
>> differ based on the which interrupt was registed.  While that can also
>> reduce cache misses that can get hairy very quickly, and of course that
>> would require read-write IDTs.
> 
> read-write IDT or GDT are fine: map them twice, once read+write, once
> read-only.  Point the GDTR and IDTR at the read-only alias.
> 

Well, it is weaker, because if you can discover the pointer to the
writable alias you win.

Now, as has been pointed out the GDT needs to be writable on 32 bits as
a matter of hardware requirement.  However, doing it for 64 bits only is
probably enough of a win.

	-hpa
