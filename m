Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110815201419.GA20296@openwall.com>
References: <20110812150304.GC16880@albatros>
	<4E45884B.8030303@zytor.com>
	<20110813062246.GC3851@albatros>
	<36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
	<m2ei0olnua.fsf@firstfloor.org>
	<632d03b0-6725-431e-b100-13f5046b03e9@email.android.com>
	<20110814092028.GB14293@openwall.com>
	<01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com>
	<20110815185114.GA20115@openwall.com>
	<4E496CAC.3030103@zytor.com>
	<20110815201419.GA20296@openwall.com>
Date: Mon, 15 Aug 2011 18:13:51 -0400
Message-ID: <CACLa4puLxL+azpYjQsD6eDKU=LPJ1mrF1LUrc5Gy-89a8fvjpQ@mail.gmail.com>
From: Eric Paris <eparis@parisplace.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Solar Designer <solar@openwall.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Vasiliy Kulikov <segoon@openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 15, 2011 at 4:14 PM, Solar Designer <solar@openwall.com> wrote:

> So how do we proceed from here? =A0Start by getting Will's patch applied?

How to move forward with Will's patch is supposed to be discussed at
the invite only kernel summit October 23 - 25, 2011.  As one of the
many people who have written a replacement for seccomp I wished I had
been invited to participate, but was not.  Will is in a hard place
because Ingo insists he take his patch in one direction while tglx and
Steven Rostedt have both explicitly NAKd such a direction.  Hopefully
when those 3 sit down in person a solution can be found and we can get
some traction on a useful seccomp interface, but it's still a while
out....

-Eric
