# amply-landing

> Лендинг для приложения **amply** (таск-трекер и канбан-доска). Проект запускается через **Docker Compose**. Ниже — проверенные инструкции **без дублей и конфликтов**.  
> Фронтенд-стили организованы компонентно: **Rails 8 + ViewComponent + Sass (Dart Sass) + Haml** с поддержкой слоёв CSS.

---

## Оглавление

- [Ссылки](#ссылки)
- [Требования](#требования)
- [Архитектура (вкратце)](#архитектура-вкратце)
- [Установка Docker и Docker Compose](#установка-docker-и-docker-compose)
- [Переменные окружения](#переменные-окружения)
- [Быстрый старт (development)](#быстрый-старт-development)
- [Ежедневные команды (development)](#ежедневные-команды-development)
  - [При запущенном контейнере](#при-запущенном-контейнере)
  - [Если контейнер не запущен](#если-контейнер-не-запущен)
- [Работа со стилями (топовый сетап)](#работа-со-стилями-топовый-сетап)
  - [Структура директорий](#структура-директорий)
  - [Единая точка входа и слои CSS](#единая-точка-входа-и-слои-css)
  - [Реестр компонентных стилей](#реестр-компонентных-стилей)
  - [Правила для компонентного CSS](#правила-для-компонентного-css)
  - [Темизация и тёмная тема](#темизация-и-тёмная-тема)
  - [Страничные стили](#страничные-стили)
  - [Линтинг/форматирование (рекомендации)](#линтингформатирование-рекомендации)
- [Компоненты ViewComponent](#компоненты-viewcomponent)
- [Полезно при создании нового проекта (Devise)](#полезно-при-создании-нового-проекта-devise)
- [Смена пароля пользователя (пример)](#смена-пароля-пользователя-пример)
- [Миграции: шаблоны и управление](#миграции-шаблоны-и-управление)
- [Генераторы и служебные команды](#генераторы-и-служебные-команды)
- [Работа с ветками Git](#работа-с-ветками-git)
- [UTM тест](#utm-тест)
- [Docker: очистка](#docker-очистка)
- [Профили Docker и запуск](#профили-docker-и-запуск)
- [Бэкапы и восстановление](#бэкапы-и-восстановление)
- [Удаление гостей и связанных данных (пример)](#удаление-гостей-и-связанных-данных-пример)
- [Экспорт выборок в JSON](#экспорт-выборок-в-json)
- [Креденшлы и master.key](#креденшлы-и-masterkey)
- [HTMLifier (.sb3 → HTML)](#htmlifier-sb3--html)
- [Importmap](#importmap)
- [Превью почты](#превью-почты)
- [Частые проблемы сборки](#частые-проблемы-сборки)
- [Структура изображений (assets/images)](#структура-изображений-assetsimages)
- [Фронтенд мелочи](#фронтенд-мелочи)
- [Троблшутинг по стилям](#троблшутинг-по-стилям)

---

## Ссылки

- Туториал по Rails: <https://agea.github.io/tutorial.md/>
- Установка Docker/Compose (Ubuntu 20.04): <https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04>

---

## Требования

- **Docker** + **Docker Compose plugin**
- **PostgreSQL** поднимается через `docker-compose`
- **Ruby on Rails** в контейнере `web`
- **cssbundling-rails** с Dart Sass (для сборки `application.css`)

> Если проект чисто фронтендовый, сохраняем Docker-оркестрацию (Nginx/Node), но Rails-команды можно пропустить.

---

## Архитектура (вкратце)

- **Rails 8 (Propshaft)** — ассеты и сборка CSS (через `cssbundling-rails`).
- **ViewComponent** — UI как компоненты: шаблон (`.html.haml`) + логика (`.rb`) + стили (`.scss`) **рядом**.
- **Sass (Dart Sass)** — только `@use`/`@forward`, **без `@import`**.
- **CSS Layers** — порядок: `base → layout → components → utilities`.

---

## Установка Docker и Docker Compose

```bash
sudo apt-get install docker-compose-plugin
```

---

## Переменные окружения

Однократно создайте `.env` (значения примерные):

```bash
echo "PGPASSWORD=change_me"        > .env
echo "PGUSER=postgres"            >> .env
echo "PGHOST=db"                  >> .env
echo "URL=http://localhost:3000"  >> .env
echo "RAILS_ENV=development"      >> .env
# при необходимости: RAILS_MASTER_KEY=...
```

---

## Быстрый старт (development)

Сборка и первичная инициализация:

```bash
# собрать образы
docker compose --profile local build

# подготовить БД (создание + миграции + сиды, если настроены)
docker compose exec web rails db:prepare
docker compose exec web rails db:seed   # опционально
```

Запуск проекта:

```bash
docker compose --profile local up
# или:
docker compose --profile local up -d
```

Открыть: <http://localhost:3000>

---

## Ежедневные команды (development)

### При запущенном контейнере

```bash
docker compose exec web bin/rails c
docker compose exec web rails db:create
docker compose exec web rails db:migrate
docker compose exec web rails db:migrate:status
docker compose exec web rails db:seed
docker compose exec web rails db:reset
docker compose exec web rails db:drop
docker compose exec web rails db:rollback STEP=1

# Тесты (RSpec)
docker compose exec web rails spec

# откат конкретной миграции
docker compose exec web rails db:migrate:down VERSION=YYYYMMDDHHMMSS
# повтор конкретной миграции
docker compose exec web rails db:migrate:up   VERSION=YYYYMMDDHHMMSS

# если используется rswag
docker compose exec web rails rswag:specs:swaggerize
```

### Если контейнер не запущен

```bash
docker compose run --rm web bin/rails c
docker compose run --rm web bin/rspec
docker compose run --rm web bundle update
docker compose run --rm web rails db:migrate
```

---

## Работа со стилями (топовый сетап)

### Структура директорий

```
app/
  components/
    ui/
      button_component.rb
      button_component.html.haml
      button_component.scss
    layout/
      header_component.{rb,html.haml,scss}
      footer_component.{rb,html.haml,scss}

app/assets/stylesheets/
  application.sass                # единая точка входа
  base/
    _reset.scss
    _variables.scss               # custom properties + sass vars
    _mixins.scss
    _typography.scss
  layers/
    _base.scss                    # @layer base   (подключает base/*)
    _layout.scss                  # @layer layout (контейнеры/сетки)
    _components.scss              # @layer components (реестр компонентов)
    _utilities.scss               # @layer utilities (утилитарные классы)
  components/
    _index.scss                   # экспорт всех component.scss
```

**Инициализация сборки CSS (один раз):**
```bash
bundle add cssbundling-rails
bin/rails css:install:sass
```

**Дать Propshaft видеть стили рядом с компонентами:**
```ruby
# config/initializers/assets.rb
Rails.application.config.assets.paths << Rails.root.join("app/components")
```

**Подключение в layout:**
```haml
= stylesheet_link_tag "application", "data-turbo-track": "reload"
```

---

### Единая точка входа и слои CSS

`app/assets/stylesheets/application.sass`
```scss
@use "base/variables";
@use "base/mixins";

/* Порядок слоёв определяет порядок применения */
@layer base, layout, components, utilities;

@use "layers/base";       // reset, типографика, custom properties
@use "layers/layout";     // контейнеры, сетки, макро-обёртки
@use "layers/components"; // весь компонентный CSS
@use "layers/utilities";  // .sr-only и т.п.
```

`app/assets/stylesheets/layers/_base.scss`
```scss
@layer base {
  @use "../base/reset";
  @use "../base/typography";

  :root {
    --brand: #5e46f8;
    --bg:    #ffffff;
    --fg:    #111111;
    --space-1: .25rem;
    --space-2: .5rem;
    --radius:  .5rem;
  }
}
```

`app/assets/stylesheets/layers/_layout.scss`
```scss
@layer layout {
  .container {
    inline-size: min(100% - 2rem, 1200px);
    margin-inline: auto;
  }
  /* при необходимости: @use "../pages/landing"; */
}
```

`app/assets/stylesheets/layers/_components.scss`
```scss
@layer components {
  @use "../components/index" as *;  // подключаем реестр компонентных стилей
}
```

`app/assets/stylesheets/layers/_utilities.scss`
```scss
@layer utilities {
  .sr-only { position:absolute; width:1px; height:1px; padding:0; margin:-1px; 
    overflow:hidden; clip:rect(0,0,0,0); white-space:nowrap; border:0; }
  .u-inline-gap { gap: var(--space-1); }
}
```

---

### Реестр компонентных стилей

`app/assets/stylesheets/components/_index.scss`
```scss
/* Явный реестр компонентных стилей (без магии) */
@forward "../../components/ui/button_component";
@forward "../../components/layout/header_component";
@forward "../../components/layout/footer_component";
/* Добавляйте новые компоненты сюда */
```

> Почему руками? Sass не умеет «глобить» пути. Явный индекс — прозрачно и предсказуемо.  
> (Опционально: rake-таск, который сканирует `app/components/**/*_component.scss` и пересобирает этот файл.)

---

### Правила для компонентного CSS

- **Нейминг**: корневой класс — пространство компонента (`.ui-button`, `.layout-header`).  
  Элементы: `&__part`, модификаторы: `&--variant-*`, `&--size-*`, `&--state-*`.
- **Изоляция**: весь CSS только под корневым классом компонента.  
  **Запрещено** писать «голые» селекторы (`h1`, `button`) в компонентных файлах.
- **Переменные**: цвета/отступы — через `var(--*)`; вычисления и миксины — Sass.
- **Слои**: каждый компонентный `.scss` **обёрнут в `@layer components`**.

**Пример компонента кнопки**

`app/components/ui/button_component.html.haml`
```haml
%button.ui-button{
  class: [
    ("ui-button--variant-#{variant}" if variant),
    ("ui-button--size-#{size}" if size)
  ]
}
  - if icon?
    %span.ui-button__icon= icon
  %span.ui-button__label= content
```

`app/components/ui/button_component.rb`
```ruby
class Ui::ButtonComponent < ViewComponent::Base
  def initialize(variant: :primary, size: :md, icon: nil)
    @variant = variant
    @size    = size
    @icon    = icon
  end
  def icon? = @icon.present?
  attr_reader :variant, :size, :icon
end
```

`app/components/ui/button_component.scss`
```scss
@layer components {
  .ui-button {
    display: inline-flex;
    align-items: center;
    gap: var(--space-1);
    padding: .5rem .75rem;
    border-radius: var(--radius);
    border: 1px solid transparent;
    cursor: pointer;

    &__icon  { inline-size: 1em; block-size: 1em; }
    &__label { line-height: 1; }

    &--variant-primary   { background: var(--brand); color: #fff; }
    &--variant-secondary { background: transparent; border-color: var(--brand); color: var(--brand); }
    &--variant-ghost     { background: transparent; color: inherit; }

    &--size-sm { font-size: .875rem; padding: .375rem .625rem; }
    &--size-md { font-size: 1rem; }
    &--size-lg { font-size: 1.125rem; padding: .625rem .875rem; }
  }
}
```

---

### Темизация и тёмная тема

В `@layer base` храним **только** переменные темы, компоненты используют `var(--*)`:

```scss
@layer base {
  :root { --brand:#5e46f8; --bg:#fff; --fg:#111; }
  [data-theme="dark"] { --brand:#8b7dff; --bg:#0b0b10; --fg:#eee; }
  html { background: var(--bg); color: var(--fg); }
}
```

---

### Страничные стили

- Если страница состоит из компонентов — глобальные стили **не нужны**.  
- Редкие макро-обёртки можно вынести в `app/assets/stylesheets/pages/_<page>.scss` и подключить в `layers/_layout.scss` через `@use`.

---

### Линтинг/форматирование (рекомендации)

- **Stylelint** (`stylelint-config-standard-scss`), правила: БЭМ-нейминг, запрет `id`-селекторов, глубина вложенности ≤ 2.
- **Prettier** или `.editorconfig` для единообразных отступов.
- CI: `stylelint "app/**/*.scss"`.

---

## Компоненты ViewComponent

```bash
rails generate component [NAMESPACE/]ComponentName [arg1:type arg2:type …]
rails g component ui/button url:string text:string
rails g component base
```

> (Опционально) Подключите **Lookbook** для превью компонентов:
> ```bash
> bundle add lookbook
> # затем добавляйте *_component.preview.rb
> ```

---

## Полезно при создании нового проекта (Devise)

```bash
bundle add devise
rails generate devise:install
rails g devise MODEL   # вместо MODEL укажите нужную модель
```

- Текущий пользователь: `current_user`
- Защита контроллеров: `before_action :authenticate_user!`

---

## Смена пароля пользователя (пример)

```ruby
user = User.find_by!(email: "user@example.com")
user.update!(password: "NewStrongPass123!", password_confirmation: "NewStrongPass123!")
```

---

## Миграции: шаблоны и управление

```bash
rails g model Pages name:string description:text h1:string alias:string
rails g model MetaTags attach:references title:text description:text keywords:text  # в миграции: t.references :attach, polymorphic: true
rails g model PageItems page:references name:string description:text alias:string
rails g model PageItemElements page_item:references name:string description:text
rails g model UserRequests phone:string email:string name:string
rails g model Apartments name:string description:text peoples:integer price:float
rails g model Services name:string description:text peoples:string price:float price_time:integer
rails g model SpecialOffers name:string description_small:string start_date:date end_date:date image:string
rails g devise Users
rails g model Roles name:string description:text
rails g model Profiles first_name:string last_name:string image:string user:references
rails g model Privileges page_name:string action_name:string role:references
```

См. команды в разделе «Ежедневные команды».

---

## Генераторы и служебные команды

```bash
# пример мейлера (для форм лендинга)
rails generate mailer MarketingMailer lead --no-helper --no-assets
```

---

## Работа с ветками Git

Удаление ветки локально:

```bash
git branch -d branch_name
```

Удаление ветки в удалённом репозитории:

```bash
git push origin --delete branch_name
```

> Рекомендуемая промежуточная ветка для обновления `main`: **staging**.

---

## UTM тест

```
http://localhost:3000/?utm_source=vya_yandex&utm_medium=cpc&utm_campaign=213213213&utm_content=123fa&utm_term=112
```

---

## Docker: очистка

Очистка всего неиспользуемого:

```bash
docker system prune
docker system prune --volumes
docker system prune -f --волumes
```

Только volumes:

```bash
docker volume prune
docker volume prune -f
```

Только остановленные контейнеры:

```bash
docker container prune
```

Образы:

```bash
docker image prune
docker image prune -a
```

Сети:

```bash
docker network prune
```

---

## Профили Docker и запуск

Профили:

- **local** — `web + db`, `RAILS_ENV=development`
- **test** — тест-окружение
- **prod** — прод-окружение

Запуск нужных сервисов:

```bash
# local
docker compose --profile local up -d db web
# test
docker compose --profile test  up -d db_test test
# prod
docker compose --profile prod  up -d db prod
```

---

## Бэкапы и восстановление

```bash
# Local: БД + файлы
scripts/backup_full.sh local backup:all

# Только БД
scripts/backup_full.sh local backup:db

# Проверка Active Storage
scripts/backup_full.sh local storage:check

# Восстановление из каталога
scripts/backup_full.sh local restore:from-dir ./backups/1.2.3.4
```

---

## Удаление гостей и связанных данных (пример)

```ruby
guest_users = User.joins(:role).where(roles: { kind: 'guest' })
Cart.where(user: guest_users).delete_all
CartItem.where(cart: Cart.where(user: guest_users)).delete_all
guest_users.delete_all
```

Удаление обычных пользователей:

```ruby
User.joins(:role).where(roles: { kind: 'user' }).destroy_all
```

---

## Экспорт выборок в JSON

```bash
# внутри контейнера
sudo docker exec amply-prod-1 \
  rails runner "File.write('/tmp/leads.json', Lead.all.to_json(only: %i[id name email source]))"

# копирование на хост (Linux)
docker cp amply-prod-1:/tmp/leads.json /home/user_name/backups/leads.json

# macOS
docker cp amply-prod-1:/tmp/leads.json /Users/user_name/backups/leads.json
```

---

## Креденшлы и master.key

Открыть/пересоздать:

```bash
EDITOR=nano rails credentials:edit
```

В контейнере:

```bash
docker compose run --rm \
  -e EDITOR="nano" \
  --volume "$PWD":/usr/src/app \
  test bin/rails credentials:edit
```

Добавить блок шифрования моделей:

```yaml
active_record_encryption:
  primary_key: <первичный_ключ>
  deterministic_key: <детерминированный_ключ>
  key_derivation_salt: <ваш_salt>
```

Проверка наличия файлов:

```bash
ls config/{master.key,credentials.yml.enc}
```

---

## Importmap

```bash
bin/importmap pin name
```

---

## Превью почты

```
http://localhost:3000/rails/mailers
```

---

## Частые проблемы сборки

Сбросить зависшие контейнеры/тома `bundle`:

```bash
docker compose --profile local down
docker volume ls | grep amply_landing_bundle | awk '{print $2}' | xargs -r docker volume rm
```

---

## Структура изображений (assets/images)

**Где:** `app/assets/images` (Propshaft). Пользовательские загрузки — через Active Storage, в `assets` их **не** кладём.

Папки:
```
app/assets/images/
  shared/
    icons/
    logos/
    illustrations/
    backgrounds/
    placeholders/
  features/
    landing/
    auth/
    billing/
  components/
    navbar/
    hero/
  vendor/
```

Именование:
- `kebab-case`: `landing-hero@1x.jpg`, `logo-dark.svg`
- Варианты: `-dark`, `-light`, языки: `-ru`, `-en`
- Мультисайз: `@1x`, `@2x` или `-320`, `-640`, `-1280`

Использование:

```erb
<%= image_tag "features/landing/hero@1x.jpg",
              alt: "Hero",
              srcset: { "features/landing/hero@2x.jpg" => "2x" } %>
```

В SCSS ERB:
```scss
.hero {
  background-image: url("<%= asset_path 'shared/backgrounds/pattern.svg' %>");
}
```

SVG:
- Монохромные — inline (изменение цвета через `currentColor`);
- Если не нужно инлайнить — `image_tag`/спрайт.

---

## Фронтенд мелочи

Ширина скроллбара:
```js
const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth;
console.log(scrollbarWidth);
```

Скачивание в `vendor`:
```bash
curl -sL https://cdn.jsdelivr.net/npm/flatpickr@4.6.13/dist/flatpickr.min.css \
  -o vendor/javascript/flatpickr/flatpickr.min.css
```

---

## Троблшутинг по стилям

**Стили компонента не применяются**
- Добавлен ли файл в `app/assets/stylesheets/components/_index.scss` через `@forward`?
- Корневой класс совпадает с разметкой?
- Файл обёрнут в `@layer components`?
- `application.sass` подключает `layers/components`?

**Конфликты специфичности**
- Используй порядок слоёв (`base → layout → components → utilities`);
- Понижай специфичность с `:where()` в базовых селекторах;
- Избегай `!important`.

**Тёмная тема не меняется**
- На `html`/`body` есть `data-theme="dark"`?
- Компоненты используют `var(--*)`, а не хардкоды?

**Общие рекомендации**
- Глубина вложенности селекторов ≤ 2;
- Только Dart Sass (`@use`/`@forward`), **никакого `@import`**;
- Нейминг: `.ns-component`, `__part`, `--modifier`.

---
