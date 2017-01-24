Date: Tue, 24 Jan 2017 16:17:04 -0500 (EST)
Message-Id: <20170124.161704.2301857219275083413.davem@davemloft.net>
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.11.1701242255570.2743@ja.home.ssi.bg>
References: <1485262100-12366-1-git-send-email-dwindsor@gmail.com>
	<alpine.LFD.2.11.1701242255570.2743@ja.home.ssi.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH net] net: free ip_vs_dest structs when refcnt=0
To: ja@ssi.bg
Cc: dwindsor@gmail.com, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, elena.reshetova@intel.com, ishkamiel@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Julian Anastasov <ja@ssi.bg>
Date: Tue, 24 Jan 2017 23:14:29 +0200 (EET)

> 	The changes look ok to me but as this is a net-next
> material I also prefer some comments in the code to be updated:

It also needs to be posted to netfilter-devel with the IPVS maintainer
CC:'d
