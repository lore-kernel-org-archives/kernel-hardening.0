Date: Thu, 8 Mar 2018 11:37:21 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH] ima: drop vla in ima_audit_measurement()
Message-ID: <20180308183721.mnsrmhekyfo2dbso@smitten>
References: <20180308171456.2597-1-tycho@tycho.ws>
 <CAHp75VfoiQ_PxBph8JnNzun4y5Z-9z_rUcjGyM7A2CAwynddeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfoiQ_PxBph8JnNzun4y5Z-9z_rUcjGyM7A2CAwynddeA@mail.gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-integrity@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 08, 2018 at 07:47:37PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 8, 2018 at 7:14 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> > In keeping with the directive to get rid of VLAs [1], let's drop the VLA
> > from ima_audit_measurement(). We need to adjust the return type of
> > ima_audit_measurement, because now this function can fail if an allocation
> > fails.
> 
> 
> 
> > +       algo_hash_len = hash_len + strlen(algo_name) + 2;
> > +       algo_hash = kzalloc(algo_hash_len, GFP_KERNEL);
> 
> > -       snprintf(algo_hash, sizeof(algo_hash), "%s:%s", algo_name, hash);
> > +       snprintf(algo_hash, algo_hash_len, "%s:%s", algo_name, hash);
> 
> kasprintf() ?

Sure, in fact I think we could just do:

-	snprintf(algo_hash, algo_hash_len, "%s:%s", algo_name, hash);
-	audit_log_untrustedstring(ab, algo_hash);
+	audit_log_untrustedstring(ab, algo_name);
+	audit_log_format(ab, ":");
+	audit_log_untrustedstring(ab, hash);

and get rid of the allocation entirely. I'll test and make sure it
works and then re-send.

Cheers,

Tycho
