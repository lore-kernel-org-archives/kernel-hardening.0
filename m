Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 14 Jun 2011 18:24:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110614142429.GB3966@albatros>
References: <1307889901-6226-1-git-send-email-segoon@openwall.com>
 <201106141554.50945.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106141554.50945.arnd@arndb.de>
Subject: [kernel-hardening] Re: [RFC v2 02/04] procfs: add hidepid modes as mount options
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, David Rientjes <rientjes@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Miklos Szeredi <mszeredi@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>, WANG Cong <xiyou.wangcong@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 14, 2011 at 15:54 +0200, Arnd Bergmann wrote:
> On Sunday 12 June 2011, Vasiliy Kulikov wrote:
> > +static const match_table_t tokens = {
> > +       {Opt_hidepid, "hidepid=%u"},
> > +       {Opt_gid, "gid=%u"},
> > +       {Opt_hidenet, "hidenet"},
> > +       {Opt_nohidenet, "nohidenet"},
> > +       {Opt_err, NULL},
> > +};
> 
> I don't really have an opinion on your patch, but it seems that it does more than
> the description explains: The hidenet/nohidenet option is in the patch as well,
> although it doesn't have much of an effect.

Correct, it is just a matter of a patch division granularity.  Alexey said
the patch should be divided into pid and net parts.  I divided it into
(pid + all mount opts parsing) and (actual hidenet usage).  As both pid
and net parts depend on options parsing, they are not fully independent,
and cannot be well splitted (or I just don't see how).

-- 
Vasiliy Kulikov
