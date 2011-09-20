Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 20 Sep 2011 08:47:37 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Message-ID: <20110920054736.GA2753@p183.telecom.by>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
 <20110630075716.GB3377@albatros>
 <BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
 <BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
 <BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
 <CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
 <20110919173905.GA3804@albatros>
 <CA+55aFzedLJfK2h2hY_a73Tn9F8Qu=LyjPhq2gVi5S=CYsCnDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzedLJfK2h2hY_a73Tn9F8Qu=LyjPhq2gVi5S=CYsCnDA@mail.gmail.com>
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Balbir Singh <bsingharora@gmail.com>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 10:45:20AM -0700, Linus Torvalds wrote:
> On Mon, Sep 19, 2011 at 10:39 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >
> > Shouldn't it simply protect taskstats_user_cmd()?  You may still poll
> > the counters with TASKSTATS_CMD_ATTR_PID/TASKSTATS_CMD_ATTR_TGID.
> 
> Yeah, I wondered where I'd really want to hook it in, that was the
> other option.
> 
> However, one thing that I'm currently independently asking some
> networking people is whether that patch guarantees anything at all: is
> the netlink command even guaranteed to be run in the same context as
> the person sending it?
> 
> After all, it comes in as a packet of data.  How synchronous is the
> genetlink thing guaranteed to be in the first place?
> 
> IOW, are *any* of those "check current capabilities/euid" approaches
> really guaranteed to be valid? Are they valid today, will they
> necessarily be valid in a year?

Netlink was made syncronous by commit cd40b7d3983c708aabe3d3008ec64ffce56d33b0
"[NET]: make netlink user -> kernel interface synchronious".
