MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1525706596-13601-1-git-send-email-s.mesoraca16@gmail.com>
References: <1525706596-13601-1-git-send-email-s.mesoraca16@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 19 Jun 2018 21:43:20 -0700
Message-ID: <CAGXu5j+Xyb0hD5iMqQHKaGdjBx2TftwU8kNgOT_rKswLsc2=qg@mail.gmail.com>
Subject: Re: [PATCH v2] net: dsa: drop some VLAs in switch.c
Content-Type: text/plain; charset="UTF-8"
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Network Development <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Florian Fainelli <f.fainelli@gmail.com>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>, David Laight <David.Laight@aculab.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 7, 2018 at 8:23 AM, Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> We avoid 2 VLAs by using a pre-allocated field in dsa_switch.
> We also try to avoid dynamic allocation whenever possible.
>
> Link: http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> Link: http://lkml.kernel.org/r/20180505185145.GB32630@lunn.ch
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>

Friendly ping. What's needed to take this into the tree? It looks like
all the issues in v1 were addressed here.

Thanks!

-Kees

> ---
>  include/net/dsa.h |  3 +++
>  net/dsa/dsa2.c    | 14 ++++++++++++++
>  net/dsa/switch.c  | 22 ++++++++++------------
>  3 files changed, 27 insertions(+), 12 deletions(-)
>
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 60fb4ec..576791d 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -256,6 +256,9 @@ struct dsa_switch {
>         /* Number of switch port queues */
>         unsigned int            num_tx_queues;
>
> +       unsigned long           *bitmap;
> +       unsigned long           _bitmap;
> +
>         /* Dynamically allocated ports, keep last */
>         size_t num_ports;
>         struct dsa_port ports[];
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index adf50fb..cebf35f0 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -748,6 +748,20 @@ struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
>         if (!ds)
>                 return NULL;
>
> +       /* We avoid allocating memory outside dsa_switch
> +        * if it is not needed.
> +        */
> +       if (n <= sizeof(ds->_bitmap) * 8) {
> +               ds->bitmap = &ds->_bitmap;
> +       } else {
> +               ds->bitmap = devm_kzalloc(dev,
> +                                         BITS_TO_LONGS(n) *
> +                                               sizeof(unsigned long),
> +                                         GFP_KERNEL);
> +               if (unlikely(!ds->bitmap))
> +                       return NULL;
> +       }
> +
>         ds->dev = dev;
>         ds->num_ports = n;
>
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index b935117..142b294 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -136,21 +136,20 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
>  {
>         const struct switchdev_obj_port_mdb *mdb = info->mdb;
>         struct switchdev_trans *trans = info->trans;
> -       DECLARE_BITMAP(group, ds->num_ports);
>         int port;
>
>         /* Build a mask of Multicast group members */
> -       bitmap_zero(group, ds->num_ports);
> +       bitmap_zero(ds->bitmap, ds->num_ports);
>         if (ds->index == info->sw_index)
> -               set_bit(info->port, group);
> +               set_bit(info->port, ds->bitmap);
>         for (port = 0; port < ds->num_ports; port++)
>                 if (dsa_is_dsa_port(ds, port))
> -                       set_bit(port, group);
> +                       set_bit(port, ds->bitmap);
>
>         if (switchdev_trans_ph_prepare(trans))
> -               return dsa_switch_mdb_prepare_bitmap(ds, mdb, group);
> +               return dsa_switch_mdb_prepare_bitmap(ds, mdb, ds->bitmap);
>
> -       dsa_switch_mdb_add_bitmap(ds, mdb, group);
> +       dsa_switch_mdb_add_bitmap(ds, mdb, ds->bitmap);
>
>         return 0;
>  }
> @@ -204,21 +203,20 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
>  {
>         const struct switchdev_obj_port_vlan *vlan = info->vlan;
>         struct switchdev_trans *trans = info->trans;
> -       DECLARE_BITMAP(members, ds->num_ports);
>         int port;
>
>         /* Build a mask of VLAN members */
> -       bitmap_zero(members, ds->num_ports);
> +       bitmap_zero(ds->bitmap, ds->num_ports);
>         if (ds->index == info->sw_index)
> -               set_bit(info->port, members);
> +               set_bit(info->port, ds->bitmap);
>         for (port = 0; port < ds->num_ports; port++)
>                 if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> -                       set_bit(port, members);
> +                       set_bit(port, ds->bitmap);
>
>         if (switchdev_trans_ph_prepare(trans))
> -               return dsa_switch_vlan_prepare_bitmap(ds, vlan, members);
> +               return dsa_switch_vlan_prepare_bitmap(ds, vlan, ds->bitmap);
>
> -       dsa_switch_vlan_add_bitmap(ds, vlan, members);
> +       dsa_switch_vlan_add_bitmap(ds, vlan, ds->bitmap);
>
>         return 0;
>  }
> --
> 1.9.1
>



-- 
Kees Cook
Pixel Security
