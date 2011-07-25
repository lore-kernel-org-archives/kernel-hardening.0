Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 25 Jul 2011 23:20:48 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110725192048.GA21675@albatros>
References: <20110723162251.GA11485@openwall.com>
 <20110724084200.GB3659@albatros>
 <20110724142710.GB18345@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724142710.GB18345@openwall.com>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Jul 24, 2011 at 18:27 +0400, Solar Designer wrote:
> What does PaX do here?

Spender's reaction: 

"The PaX position on the null bytes in mmap addresses is: the tradeoff
between stopping certain vulns involving string functions and having low
entropy for every other vuln type, and having the same high entropy for
all types is weighed in favor of the latter."

-- 
Vasiliy
