Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <58295796-9bb5-080a-4c4d-47761d0876a9@gmail.com>
Date: Wed, 31 Oct 2018 11:27:00 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>



On 30/10/2018 18:37, Kees Cook wrote:
> On Tue, Oct 30, 2018 at 8:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> I suppose the 'normal' attack goes like:
>>
>>   1) find buffer-overrun / bound check failure
>>   2) use that to write to 'interesting' location
>>   3) that write results arbitrary code execution
>>   4) win
>>
>> Of course, if the store of 2 is to the current cred structure, and
>> simply sets the effective uid to 0, we can skip 3.
> 
> In most cases, yes, gaining root is game over. However, I don't want
> to discount other threat models: some systems have been designed not
> to trust root, so a cred attack doesn't always get an attacker full
> control (e.g. lockdown series, signed modules, encrypted VMs, etc).

Reading these points I see where I was not clear.

Maybe I can fix that. SELinux is a good example of safeguard against a 
takeover of root, so it is a primary target. Unfortunately it contains 
some state variables that can be used to disable it.

Other attack that comes to my mind, for executing code within the 
kernel, without sweating too much with ROP is the following:

1) find the rabbit hole to write kernel data, whatever it might be
2) spray the keyring with own key
3) use the module loading infrastructure to load own module, signed with 
the key at point 2)

Just to say that direct arbitrary code execution is becoming harder to 
perform, but there are ways around it which rely more on overwriting 
unprotected data.

They are a lower hanging fruit for an attacker.

--
igor
