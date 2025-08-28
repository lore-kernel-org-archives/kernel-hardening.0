Return-Path: <kernel-hardening-return-21994-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 7DB69CA0EED
	for <kernel-hardening@archiver.kernel.org>; Thu, 28 Aug 2025 21:01:26 +0000 (UTC)
Received: (qmail 32583 invoked by uid 550); 28 Aug 2025 21:01:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32545 invoked from network); 28 Aug 2025 21:01:16 -0000
Date: Thu, 28 Aug 2025 16:01:07 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Luca Boccassi <bluca@debian.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>,
	Robert Waite <rowait@microsoft.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Scott Shell <scottsh@microsoft.com>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
Message-ID: <aLDDk4x7QBKxLmoi@mail.hallyn.com>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net>
 <2025-08-27-obscene-great-toy-diary-X1gVRV@cyphar.com>
 <CALCETrWHKga33bvzUHnd-mRQUeNXTtXSS8Y8+40d5bxv-CqBhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWHKga33bvzUHnd-mRQUeNXTtXSS8Y8+40d5bxv-CqBhw@mail.gmail.com>

On Wed, Aug 27, 2025 at 05:32:02PM -0700, Andy Lutomirski wrote:
> On Wed, Aug 27, 2025 at 5:14 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> >
> > On 2025-08-26, Mickaël Salaün <mic@digikod.net> wrote:
> > > On Tue, Aug 26, 2025 at 11:07:03AM +0200, Christian Brauner wrote:
> > > > Nothing has changed in that regard and I'm not interested in stuffing
> > > > the VFS APIs full of special-purpose behavior to work around the fact
> > > > that this is work that needs to be done in userspace. Change the apps,
> > > > stop pushing more and more cruft into the VFS that has no business
> > > > there.
> > >
> > > It would be interesting to know how to patch user space to get the same
> > > guarantees...  Do you think I would propose a kernel patch otherwise?
> >
> > You could mmap the script file with MAP_PRIVATE. This is the *actual*
> > protection the kernel uses against overwriting binaries (yes, ETXTBSY is
> > nice but IIRC there are ways to get around it anyway).
> 
> Wait, really?  MAP_PRIVATE prevents writes to the mapping from
> affecting the file, but I don't think that writes to the file will
> break the MAP_PRIVATE CoW if it's not already broken.
> 
> IPython says:
> 
> In [1]: import mmap, tempfile
> 
> In [2]: f = tempfile.TemporaryFile()
> 
> In [3]: f.write(b'initial contents')
> Out[3]: 16
> 
> In [4]: f.flush()
> 
> In [5]: map = mmap.mmap(f.fileno(), f.tell(), flags=mmap.MAP_PRIVATE,
> prot=mmap.PROT_READ)
> 
> In [6]: map[:]
> Out[6]: b'initial contents'
> 
> In [7]: f.seek(0)
> Out[7]: 0
> 
> In [8]: f.write(b'changed')
> Out[8]: 7
> 
> In [9]: f.flush()
> 
> In [10]: map[:]
> Out[10]: b'changed contents'

That was surprising to me, however, if I split the reader
and writer into different processes, so

P1:
f = open("/tmp/3", "w")
f.write('initial contents')
f.flush()

P2:
import mmap
f = open("/tmp/3", "r")
map = mmap.mmap(f.fileno(), f.tell(), flags=mmap.MAP_PRIVATE, prot=mmap.PROT_READ)

Back to P1:
f.seek(0)
f.write('changed')

Back to P2:
map[:]

Then P2 gives me:

b'initial contents'

-serge
