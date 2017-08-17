Date: Thu, 17 Aug 2017 07:40:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170817144043.GA10717@infradead.org>
References: <CAGXu5jKu6JWC6hw4BYGPA+qatMdd-SiaO2LiJy6XnAfjbU+1Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKu6JWC6hw4BYGPA+qatMdd-SiaO2LiJy6XnAfjbU+1Rw@mail.gmail.com>
Subject: [kernel-hardening] Re: refactoring timers to avoid init_timer*()
To: Kees Cook <keescook@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Instea of bloating the timer even more we should kill off
the data field eventually, which should give you the same
protection.

See my proposal and the related discussion here:

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1397209.html
