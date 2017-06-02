MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1496425271.1989.1.camel@gmail.com>
References: <CAHmME9q=AdK7BHQw0+sd4T0HGQce92KXTD+-TTc2s2CXbEHAAA@mail.gmail.com>
 <CAHmME9omJTaP1C=yUh3913Cv1gF1pBtpy9cmEMyJG4yw_dnZWQ@mail.gmail.com> <1496425271.1989.1.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 2 Jun 2017 11:58:25 -0700
Message-ID: <CAGXu5jLXMsM1rGzK7hot7qWOWJNW5V_NnCks1YZ3SKhCoHZxjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: get_random_bytes returns bad randomness
 before seeding is complete
To: Daniel Micay <danielmicay@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Stephan Mueller <smueller@chronox.de>, Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 2, 2017 at 10:41 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> On Fri, 2017-06-02 at 17:53 +0200, Jason A. Donenfeld wrote:
>> (Meanwhile...)
>>
>> In my own code, I'm currently playing with a workaround that looks
>> like this:
>>
>> --- a/src/main.c
>> +++ b/src/main.c
>>
>> +#include <linux/completion.h>
>> +#include <linux/random.h>
>>
>> +struct rng_initializer {
>> +       struct completion done;
>> +       struct random_ready_callback cb;
>> +};
>> +static void rng_initialized_callback(struct random_ready_callback
>> *cb)
>> +{
>> +       complete(&container_of(cb, struct rng_initializer, cb)->done);
>> +}
>> +
>> static int __init mod_init(void)
>> {
>>        int ret;
>> +       struct rng_initializer rng = {
>> +               .done = COMPLETION_INITIALIZER(rng.done),
>> +               .cb = { .owner = THIS_MODULE, .func =
>> rng_initialized_callback }
>> +       };
>> +
>> +       ret = add_random_ready_callback(&rng.cb);
>> +       if (!ret)
>> +               wait_for_completion(&rng.done);
>> +       else if (ret != -EALREADY)
>> +               return ret;
>>
>>        do_things_with_get_random_bytes_maybe();
>>
>> Depending on the situation, however, I could imagine that
>> wait_for_completion never returning, if its blocking activity that
>> contributes to the seed actually being available, if this is called
>> from a compiled-in module, so I find this a bit sub-optimal...
>
> One of the early uses is initializing the stack canary value for SSP in
> very early boot. If that blocks, it's going to be blocking nearly
> anything else from happening.
>
> On x86, that's only the initial canary since the per-task canaries end
> up being used, but elsewhere at least without SMP disabled or changes to
> GCC that's all there is so the entropy matters.

And just to note, building with GCC_PLUGIN_LATENT_ENTROPY, while it
(correctly) doesn't credit entropy to the pool, should at least make
the pool less deterministic between boots.

-Kees

-- 
Kees Cook
Pixel Security
