Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110629191615.GA9343@albatros>
References: <1308163895-5963-1-git-send-email-segoon@openwall.com>
	<20110621153102.762557f3.akpm@linux-foundation.org>
	<20110622064545.GA3605@albatros>
	<20110629191615.GA9343@albatros>
Date: Wed, 6 Jul 2011 14:25:33 +0300
Message-ID: <CACVxJT-R-+Nji5Cu_by1phJSSor_fT2_Pwtn24vpK49PZ_LHEg@mail.gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC 0/5 v4] procfs: introduce hidepid=, hidenet=, gid= mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 29, 2011 at 10:16 PM, Vasiliy Kulikov <segoon@openwall.com> wro=
te:
>> =A0 =A0 mount -t proc -o "pid_allow=3Dexe,status,comm,oom_*" proc /proc
>
> Does this scheme make sense? =A0Should I rensend the patch with these
> architecture?
>
> pid_allow=3D, tid_allow=3D, attr_allow=3D and watch_gid=3D or smth like t=
hat.

Wildcards are scary, can we please not do them from the beginning.
