Date: Mon, 12 Mar 2018 11:14:32 -0400 (EDT)
Message-Id: <20180312.111432.849792523664957837.davem@davemloft.net>
Subject: Re: [PATCH] net: llc: drop VLA in llc_sap_mcast()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1520802724-17509-1-git-send-email-s.mesoraca16@gmail.com>
References: <1520802724-17509-1-git-send-email-s.mesoraca16@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: s.mesoraca16@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com, rientjes@google.com, elena.reshetova@intel.com, ishkamiel@gmail.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 11 Mar 2018 22:12:04 +0100

> Avoid a VLA[1] by using a real constant expression instead of a variable.
> The compiler should be able to optimize the original code and avoid using
> an actual VLA. Anyway this change is useful because it will avoid a false
> positive with -Wvla, it might also help the compiler generating better
> code.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>

Applied.
