MIME-Version: 1.0
In-Reply-To: <1494338600.2410.6.camel@sipsolutions.net>
References: <20170509135009.13751-1-Jason@zx2c4.com> <1494338600.2410.6.camel@sipsolutions.net>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 9 May 2017 16:08:56 +0200
Message-ID: <CAHmME9rB3RbSBOkjmqHv-uO9eHEEhLXZf_Q5_hZ7jiLhzpo_Wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 0/5] skb_to_sgvec hardening
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 9, 2017 at 4:03 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Perhaps you should add __must_check annotation to the function
> prototype(s)?

Great idea. I've started doing this in my own code. Wasn't sure how
popular it was outside of there, but I'm glad to hear a suggestion of
it now. I'll have this in v8.
