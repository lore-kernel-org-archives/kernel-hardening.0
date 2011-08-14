Reply-To: kernel-hardening@lists.openwall.com
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com>
In-Reply-To: <20110814092028.GB14293@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 14 Aug 2011 07:48:51 -0700
Message-ID: <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com>
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Solar Designer <solar@openwall.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vasiliy Kulikov <segoon@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Solar Designer <solar@openwall.com> wrote:

>On Sat, Aug 13, 2011 at 10:08:57PM -0700, H. Peter Anvin wrote:
>> Andi Kleen <andi@firstfloor.org> wrote:
>> 
>> >Sounds to me a better alternative would be more aggressive,
>pro-active
>> >fuzzing of the compat calls.
>[...]
>> Agreed.  Other than that, I can see a fine-grained permission filter,

>but the compat vs noncompat axis is just spurious.
>
>In case anyone cares, I respectfully disagree.  I am with Vasiliy on
>this.  I think that proactive fuzzing is great, but it is not an
>alternative - we can also do both fuzzing and reduction of attack
>surface at once.  With Vasiliy reusing an existing check (in a future
>revision of the patch), there's not going to be any performance impact.
>Fine-grained restrictions would be great, but the 32- vs. 64-bit
>restriction makes sense to me as well.  I expect different systems to
>use these different kinds of restrictions in different cases.
>
>We will definitely want to support x32 as well.  We'd appreciate any
>suggestions on how to do it best.
>
>Thanks,
>
>Alexander

i386 vs x86-64 vs x32 is just one of many axes along which syscalls can be restricted (and for that matter, one axis if backward compatibility), and it does not make sense to burden the code with ad hoc filters.  Designing a general filter facility which can be used to restrict any container to the subset of system calls it actually needs would make more sense, no?
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
