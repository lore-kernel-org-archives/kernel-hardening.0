MIME-Version: 1.0
In-Reply-To: <20180308171456.2597-1-tycho@tycho.ws>
References: <20180308171456.2597-1-tycho@tycho.ws>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 8 Mar 2018 19:47:37 +0200
Message-ID: <CAHp75VfoiQ_PxBph8JnNzun4y5Z-9z_rUcjGyM7A2CAwynddeA@mail.gmail.com>
Subject: Re: [PATCH] ima: drop vla in ima_audit_measurement()
Content-Type: text/plain; charset="UTF-8"
To: Tycho Andersen <tycho@tycho.ws>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-integrity@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 7:14 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> In keeping with the directive to get rid of VLAs [1], let's drop the VLA
> from ima_audit_measurement(). We need to adjust the return type of
> ima_audit_measurement, because now this function can fail if an allocation
> fails.



> +       algo_hash_len = hash_len + strlen(algo_name) + 2;
> +       algo_hash = kzalloc(algo_hash_len, GFP_KERNEL);

> -       snprintf(algo_hash, sizeof(algo_hash), "%s:%s", algo_name, hash);
> +       snprintf(algo_hash, algo_hash_len, "%s:%s", algo_name, hash);

kasprintf() ?

-- 
With Best Regards,
Andy Shevchenko
