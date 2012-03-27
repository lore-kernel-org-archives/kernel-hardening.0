Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1332875639.16159.255.camel@twins>
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 27 Mar 2012 21:13:59 +0200
In-Reply-To: <CA+5PVA5FR_QoTtNVV04VXrjOujAMFHMXF4-GnyZHLPUGnvb3zA@mail.gmail.com>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	 <20120323190855.GA27213@www.outflux.net>
	 <CA+5PVA5FR_QoTtNVV04VXrjOujAMFHMXF4-GnyZHLPUGnvb3zA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: Josh Boyer <jwboyer@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Darren Hart <dvhart@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2012-03-27 at 14:05 -0400, Josh Boyer wrote:
>=20
> Do you really need WARN_ONCE?  It's going to spew a backtrace if this
> is called, and that is going to cause various auto-bug reporters to file
> bugs as well. =20

That's a positive, right? That gives extra visibility to who and what
might possibly use this thing.
