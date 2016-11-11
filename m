Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Fri, 11 Nov 2016 09:06:10 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41BFF6CB@IRSMSX102.ger.corp.intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-2-git-send-email-elena.reshetova@intel.com>
 <20161110213535.GA3117@twins.programming.kicks-ass.net>
In-Reply-To: <20161110213535.GA3117@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] Re: [RFC v4 PATCH 01/13] Add architecture
 independent hardened atomic base
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 10:24:36PM +0200, Elena Reshetova wrote:
>  include/asm-generic/local.h                |   3 +
>  include/asm-generic/local_wrap.h           |  63 +++++++++++

>Seriously? Is there a single instance of local_t where any of this matters=
?

Oh, I would be the first person to vote for dropping the local_t changes ou=
t of this patchset!=20
(we actually proposed this in past). Reason why we had to deal with it is t=
hat couple of places=20
(like kernel/trace/ring_buffer.c ) utilizes local_t extensively for stuff w=
e want to allow to overflow,
like indexing and etc.  So, if we want to opt-out of protection for that ty=
pes and preserve the
overall logic of the changes, we need to add the local_*_wrap() functions. =
But local changes=20
is such a pain and used so little, that would be great to solve it in other=
 way than this. Just so far
noone suggested a better way.=20
