Date: Mon, 12 Mar 2018 15:07:57 -0400 (EDT)
Message-Id: <20180312.150757.1880237990834088910.davem@davemloft.net>
Subject: Re: [PATCH 1/2] net: rds: drop VLA in rds_for_each_conn_info()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
References: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: s.mesoraca16@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, keescook@chromium.org, santosh.shilimkar@oracle.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 11 Mar 2018 22:07:49 +0100

> Avoid VLA[1] by using an already allocated buffer passed
> by the caller.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>

Applied.
