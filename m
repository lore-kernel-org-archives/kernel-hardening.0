Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 14 Jun 2011 15:54:50 +0200
References: <1307889901-6226-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1307889901-6226-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106141554.50945.arnd@arndb.de>
Subject: [kernel-hardening] Re: [RFC v2 02/04] procfs: add hidepid modes as mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, David Rientjes <rientjes@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>, Miklos Szeredi <mszeredi@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>, WANG Cong <xiyou.wangcong@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sunday 12 June 2011, Vasiliy Kulikov wrote:
> +static const match_table_t tokens = {
> +       {Opt_hidepid, "hidepid=%u"},
> +       {Opt_gid, "gid=%u"},
> +       {Opt_hidenet, "hidenet"},
> +       {Opt_nohidenet, "nohidenet"},
> +       {Opt_err, NULL},
> +};

I don't really have an opinion on your patch, but it seems that it does more than
the description explains: The hidenet/nohidenet option is in the patch as well,
although it doesn't have much of an effect.

	Arnd
