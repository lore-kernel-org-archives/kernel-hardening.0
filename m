Date: Mon, 12 Mar 2018 15:08:15 -0400 (EDT)
Message-Id: <20180312.150815.1091524401090660262.davem@davemloft.net>
Subject: Re: [PATCH 2/2] net: rds: drop VLA in rds_walk_conn_path_info()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1520802470-17374-2-git-send-email-s.mesoraca16@gmail.com>
References: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
	<1520802470-17374-2-git-send-email-s.mesoraca16@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: s.mesoraca16@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, keescook@chromium.org, santosh.shilimkar@oracle.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 11 Mar 2018 22:07:50 +0100

> Avoid VLA[1] by using an already allocated buffer passed
> by the caller.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>

Also applied, thanks.
