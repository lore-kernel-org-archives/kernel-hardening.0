Return-Path: <kernel-hardening-return-21712-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2DB54C00A8F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Oct 2023 16:11:59 +0000 (UTC)
Received: (qmail 23615 invoked by uid 550); 24 Oct 2023 16:11:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23580 invoked from network); 24 Oct 2023 16:11:49 -0000
Date: Tue, 24 Oct 2023 11:11:38 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Boris Lukashev <blukashev@sempervictus.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
	kernel-hardening@lists.openwall.com,
	Stefan Bavendiek <stefan.bavendiek@mailbox.org>,
	linux-hardening@vger.kernel.org
Subject: Re: Isolating abstract sockets
Message-ID: <20231024161138.GB323539@mail.hallyn.com>
References: <Y59qBh9rRDgsIHaj@mailbox.org>
 <20231024134608.GC320399@mail.hallyn.com>
 <BE62D2CD-63CD-435A-A290-4608CF1A46D4@sempervictus.com>
 <20231024141512.GA321218@mail.hallyn.com>
 <CAFUG7Cfzg7LaQhhN_Vk+doOzXQ_3n4aY--mK2mORsd36MWWJjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFUG7Cfzg7LaQhhN_Vk+doOzXQ_3n4aY--mK2mORsd36MWWJjQ@mail.gmail.com>

Yeah, I think I've heard the term "socket namespaces" before, and I
agree that changing the term 'network namespaces' in the kernel would
probably not be practical at this point.

On Tue, Oct 24, 2023 at 11:55:43AM -0400, Boris Lukashev wrote:
> Good point: from the "resources granted to a user" perspective, that does
> help bound their consumption. The nomenclature distinction seems like a
> good one to have, but if "network namespaces" *change the meaning of the
> term *and the original definition becomes "network device namespaces," then
> there would be a period where older and newer kernels have very different
> functions mapped to the same conceptual name. Might this make a bit more
> sense as "network namespaces" meaning what they do now - "network device
> namespaces," effectively; while the new concept would be "socket
> namespaces" to account for the various socket style interfaces provided?
> 
> Thanks
> -Boris
> 
> On Tue, Oct 24, 2023 at 10:15 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> 
> > Thanks for the reply.  Do you have any papers which came out of this r&d
> > phase?  Sounds very interesting.
> >
> > > Multiple NS' sharing an IP stack would exhaust ephemeral ranges faster
> >
> > Yes, but that could be a feature.  I think of it as:  I'm unprivileged
> > user serge, and I want to fire off firefox in a whatzit-namespace so
> > that I can redirect or forbid some connections.  In this case, the
> > admins have not agreed to let me double my resource usage, so the fact
> > that the new namespace is sharing mine is a feature.  And this lets
> > me use network-namespace-like features completely unprivileged, without
> > having to use a setuid-root helper to hook up a bridge.
> >
> > But, I didn't send this reply to advocate this approach.  My main point
> > was to mention that "network namespaces are network device namespaces"
> > and hope that others would bring other suggestions for alternatives.
> >
> > -serge
> >
> > On Tue, Oct 24, 2023 at 10:05:29AM -0400, Boris Lukashev wrote:
> > > Namespacing at OSI4 seems a bit fraught as the underlying route, mac,
> > and physdev fall outside the callers control. Multiple NS' sharing an IP
> > stack would exhaust ephemeral ranges faster (likely asymmetrically too) and
> > have bound socket collisions opaque to each other requiring handling
> > outside the NS/containers purview. We looked at this sort of thing during
> > the r&d phase of our assured comms work (namespaces were young) and found a
> > bunch of overhead and collision concerns. Not saying it can't be done, but
> > getting consumers to play nice enough with such an approach may be a heavy
> > lift.
> > >
> > > Thanks,
> > > -Boris
> > >
> > >
> > > On October 24, 2023 9:46:08 AM EDT, "Serge E. Hallyn" <serge@hallyn.com>
> > wrote:
> > > >On Sun, Dec 18, 2022 at 08:29:10PM +0100, Stefan Bavendiek wrote:
> > > >> When building userspace application sandboxes, one issue that does
> > not seem trivial to solve is the isolation of abstract sockets.
> > > >
> > > >Veeery late reply.  Have you had any productive discussions about this
> > in
> > > >other threads or venues?
> > > >
> > > >> While most IPC mechanism can be isolated by mechanisms like mount
> > namespaces, abstract sockets are part of the network namespace.
> > > >> It is possible to isolate abstract sockets by using a new network
> > namespace, however, unprivileged processes can only create a new empty
> > network namespace, which removes network access as well and makes this
> > useless for network clients.
> > > >>
> > > >> Same linux sandbox projects try to solve this by bridging the
> > existing network interfaces into the new namespace or use something like
> > slirp4netns to archive this, but this does not look like an ideal solution
> > to this problem, especially since sandboxing should reduce the kernel
> > attack surface without introducing more complexity.
> > > >>
> > > >> Aside from containers using namespaces, sandbox implementations based
> > on seccomp and landlock would also run into the same problem, since
> > landlock only provides file system isolation and seccomp cannot filter the
> > path argument and therefore it can only be used to block new unix domain
> > socket connections completely.
> > > >>
> > > >> Currently there does not seem to be any way to disable network
> > namespaces in the kernel without also disabling unix domain sockets.
> > > >>
> > > >> The question is how to solve the issue of abstract socket isolation
> > in a clean and efficient way, possibly even without namespaces.
> > > >> What would be the ideal way to implement a mechanism to disable
> > abstract sockets either globally or even better, in the context of a
> > process.
> > > >> And would such a patch have a realistic chance to make it into the
> > kernel?
> > > >
> > > >Disabling them altogether would break lots of things depending on them,
> > > >like X :)  (@/tmp/.X11-unix/X0).  The other path is to reconsider
> > network
> > > >namespaces.  There are several directions this could lead.  For one, as
> > > >Dinesh Subhraveti often points out, the current "network" namespace is
> > > >really a network device namespace.  If we instead namespace at the
> > > >bind/connect/etc calls, we end up with much different abilities.  You
> > > >can implement something like this today using seccomp-filter.
> > > >
> > > >-serge
> >
> 
> 
> -- 
> Boris Lukashev
> Systems Architect
> Semper Victus <https://www.sempervictus.com>
