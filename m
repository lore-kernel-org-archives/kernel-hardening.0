Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4E498616.8030503@zytor.com>
Date: Mon, 15 Aug 2011 13:48:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com> <20110815185114.GA20115@openwall.com> <4E496CAC.3030103@zytor.com> <20110815201419.GA20296@openwall.com>
In-Reply-To: <20110815201419.GA20296@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Solar Designer <solar@openwall.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vasiliy Kulikov <segoon@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 08/15/2011 01:14 PM, Solar Designer wrote:
> 
> There is a difference from a sysadmin standpoint
>

Sysadmin differences don't belong in the kernel interfaces or internals;
they are packaging.

	-hpa
