Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 02 Dec 2015 23:50:49 -0500 (EST)
Message-Id: <20151202.235049.2068953758962834535.davem@davemloft.net>
From: David Miller <davem@davemloft.net>
In-Reply-To: <87egf7183c.fsf_-_@x220.int.ebiederm.org>
References: <565B7F7D.80208@nod.at>
	<CAGXu5jJqQKAmFK0nL69E0QOpo8WSVDqStGZo7-m7gy3vnXBa=A@mail.gmail.com>
	<87egf7183c.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH net] bridge: Only call /sbin/bridge-stp for the initial
 network namespace
To: ebiederm@xmission.com
Cc: richard@nod.at, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, bridge@lists.linux-foundation.org, stephen@networkplumber.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 30 Nov 2015 15:38:15 -0600

> +	if (dev_net(br->dev) == &init_net)

Please respin this using net_eq() as Hannes pointed out.

Thanks.
