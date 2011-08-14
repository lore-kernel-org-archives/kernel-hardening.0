Reply-To: kernel-hardening@lists.openwall.com
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org>
In-Reply-To: <m2ei0olnua.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 13 Aug 2011 22:08:57 -0700
Message-ID: <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com>
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Andi Kleen <andi@firstfloor.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Andi Kleen <andi@firstfloor.org> wrote:

>"H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> IA64 is totally different.  I'm extremely sceptical to this patch; it
>feels like putting code in a super-hot path to paper over a problem
>that has to be fixed anyway.
>
>Sounds to me a better alternative would be more aggressive, pro-active
>fuzzing of the compat calls.
>
>-Andi
>
>-- 
>ak@linux.intel.com -- Speaking for myself only

Agreed.  Other than that, I can see a fine-grained permission filter, but the compat vs noncompat axis is just spurious.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
