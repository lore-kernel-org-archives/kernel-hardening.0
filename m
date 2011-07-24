Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 24 Jul 2011 12:39:07 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110724083907.GA3659@albatros>
References: <20110718194803.GA5337@albatros>
 <20110723150658.GA11156@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723150658.GA11156@openwall.com>
Subject: Re: [kernel-hardening] GNU_STACK policy problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar, Eugene,

On Sat, Jul 23, 2011 at 19:06 +0400, Solar Designer wrote:
> I started looking into this, and here's what I found in RHEL 5 kernels:

Very interesting.  The same code is present in RHEL 6.  However, I don't
see the problem of GNU_STACK in DSOs is somehow solved.  Maybe RHEL 6
glibc has appropriate patches for loader?

-- 
Vasiliy
