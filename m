Return-Path: <kernel-hardening-return-21715-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2C06EC0032E
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Oct 2023 17:22:56 +0000 (UTC)
Received: (qmail 21803 invoked by uid 550); 25 Oct 2023 17:22:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21771 invoked from network); 25 Oct 2023 17:22:47 -0000
Date: Wed, 25 Oct 2023 12:22:35 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jann Horn <jannh@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
	Stefan Bavendiek <stefan.bavendiek@mailbox.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: Isolating abstract sockets
Message-ID: <20231025172235.GA345747@mail.hallyn.com>
References: <Y59qBh9rRDgsIHaj@mailbox.org>
 <20231024134608.GC320399@mail.hallyn.com>
 <CAG48ez2DF4unFq7wXqHVdUg+o_VYee012v0hUiGTbfnTpsPi0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez2DF4unFq7wXqHVdUg+o_VYee012v0hUiGTbfnTpsPi0w@mail.gmail.com>

On Wed, Oct 25, 2023 at 07:10:07PM +0200, Jann Horn wrote:
> On Tue, Oct 24, 2023 at 3:46 PM Serge E. Hallyn <serge@hallyn.com> wrote:
> > Disabling them altogether would break lots of things depending on them,
> > like X :)  (@/tmp/.X11-unix/X0).
> 
> FWIW, X can connect over both filesystem-based unix domain sockets and
> abstract unix domain sockets. When a normal X client tries to connect
> to the server, it'll try a bunch of stuff, including an abstract unix
> socket address, a filesystem-based unix socket address, and TCP:
> 
> $ DISPLAY=:12345 strace -f -e trace=connect xev >/dev/null
> connect(3, {sa_family=AF_UNIX, sun_path=@"/tmp/.X11-unix/X12345"}, 24)
> = -1 ECONNREFUSED (Connection refused)
> connect(3, {sa_family=AF_UNIX, sun_path="/tmp/.X11-unix/X12345"}, 110)
> = -1 ENOENT (No such file or directory)
> [...]
> connect(3, {sa_family=AF_INET, sin_port=htons(18345),
> sin_addr=inet_addr("127.0.0.1")}, 16) = 0
> connect(3, {sa_family=AF_INET6, sin6_port=htons(18345),
> inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=htonl(0),
> sin6_scope_id=0}, 28) = 0
> connect(3, {sa_family=AF_INET6, sin6_port=htons(18345),
> inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=htonl(0),
> sin6_scope_id=0}, 28) = -1 ECONNREFUSED (Connection refused)
> connect(3, {sa_family=AF_INET, sin_port=htons(18345),
> sin_addr=inet_addr("127.0.0.1")}, 16) = -1 ECONNREFUSED (Connection
> refused)
> 
> And the X server normally listens on both an abstract and a
> filesystem-based unix socket address (see "netstat --unix -lnp").
> 
> So rejecting abstract unix socket connections shouldn't prevent an X
> client from connecting to the X server, I think.

Well it was just an example :)  Dbus is another.  But maybe all
the users of abstract unix sockets will fall back gracefully to
something else.  That'd be nice.

For X, abstract really doesn't even make sense to me.  Has it always
supported that?
