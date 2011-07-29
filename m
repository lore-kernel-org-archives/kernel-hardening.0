Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 29 Jul 2011 13:09:07 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110729090907.GA7466@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] networking restrictions
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Looks like it touches the restrictions of per net_ns socket
creation/usage:

https://lwn.net/Articles/368730/

However, I want to implement it as a cgroup policy similar to device
creation/usage restriction.  AFAICS, cgroup was not suggested in the
topic.


Thanks,

-- 
Vasiliy
