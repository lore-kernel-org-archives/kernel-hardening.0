Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 30 Jul 2011 22:57:02 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110730185702.GA4667@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] mmap guard pages
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

What do you think about this?

http://www.openbsd.org/papers/ven05-deraadt/mgp00025.html

In short, each mmap call adds guard pages before and after the allocated
memory.  It should catch overflows/underflows of mmap-based buffers.
AFAICS, it's possible to painlessly (in terms of vm waste) enable it on
x86-64.


Thanks,

-- 
Vasiliy
