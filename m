MIME-Version: 1.0
In-Reply-To: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 2 Jun 2017 17:53:39 +0200
Message-ID: <CAHmME9omJTaP1C=yUh3913Cv1gF1pBtpy9cmEMyJG4yw_dnZWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: get_random_bytes returns bad randomness before seeding is complete
To: Stephan Mueller <smueller@chronox.de>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

(Meanwhile...)

In my own code, I'm currently playing with a workaround that looks like this:

--- a/src/main.c
+++ b/src/main.c

+#include <linux/completion.h>
+#include <linux/random.h>

+struct rng_initializer {
+       struct completion done;
+       struct random_ready_callback cb;
+};
+static void rng_initialized_callback(struct random_ready_callback *cb)
+{
+       complete(&container_of(cb, struct rng_initializer, cb)->done);
+}
+
static int __init mod_init(void)
{
       int ret;
+       struct rng_initializer rng = {
+               .done = COMPLETION_INITIALIZER(rng.done),
+               .cb = { .owner = THIS_MODULE, .func = rng_initialized_callback }
+       };
+
+       ret = add_random_ready_callback(&rng.cb);
+       if (!ret)
+               wait_for_completion(&rng.done);
+       else if (ret != -EALREADY)
+               return ret;

       do_things_with_get_random_bytes_maybe();

Depending on the situation, however, I could imagine that
wait_for_completion never returning, if its blocking activity that
contributes to the seed actually being available, if this is called
from a compiled-in module, so I find this a bit sub-optimal...
